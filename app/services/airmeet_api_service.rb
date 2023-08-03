module AirmeetApiService
  def self.integration
    @integration ||= Integration.find_or_create_by({name: :airmeet})
  end

  def self.config
    integration.config
  end

  def self.token
    if !config['token'] || Time.at(config['token_exp']) < Time.now
      auth
    else
      config['token']
    end
  end

  def self.airmeet_id
    config['airmeet_id']
  end

  def self.airmeet
    @airmeet ||= Airmeet.new
  end

  def self.get_participants
    Airmeet.get("/airmeet/#{airmeet_id}/participants")
  end

  def self.auth
    token = airmeet.auth["token"]
    integration.update({config: config.merge({ 
      token: token, 
      token_exp: (Time.now + (29 * 24 * 60 * 60)).to_i 
    })})
    token
  end

  def self.info
    Airmeet.get("/airmeet/#{airmeet_id}/info")
  end

  def self.get_session(id)
    info["sessions"].find { |s| s["sessionid"] == id }
  end

  def self.create_session(sessionTitle:, sessionStartTime:, sessionDuration:, sessionSummary:, hostEmail:, speakerEmails: [], cohostEmails: [])
    sessionStartTime = sessionStartTime.to_i * 1000
    Airmeet.post("/airmeet/#{airmeet_id}/session", {
      body: {
        sessionTitle: sessionTitle,
        sessionStartTime: sessionStartTime,
        sessionDuration: sessionDuration,
        sessionSummary: sessionSummary,
        hostEmail: hostEmail,
        speakerEmails: speakerEmails,
        cohostEmails: cohostEmails,
        type: "HOSTING"
      }.to_json
    })
  end

  def self.create_speaker(name:, email:, organisation: "", designation: "", imageUrl:  "", bio: "", city: "", country: "")
    Airmeet.post("/airmeet/#{airmeet_id}/speaker", {
      body: {
        name: name,
        email: email,
        organisation: organisation,
        designation: designation,
        imageUrl: imageUrl,
        bio: bio || " ",
        city: city,
        country: country,
      }.to_json
    })
  end

  def self.person_to_airmeet(person, dont_send = false)
    begin
      if !person.registered
        p "skipping #{person.primary_email.email} - they are not registered"
        return
      end
      speaker_email = person.primary_email.email
      country = nil
      city = nil
      if person.integrations["airmeet"] 
        speaker_email = person.integrations["airmeet"]["speaker_email"] || speaker_email
        country = person.integrations["airmeet"]["country"]
        city = person.integrations["airmeet"]["city"]
      end
      name = person.published_name
      bio = ActionView::Base.full_sanitizer.sanitize(person.bio)
      args = {name: name, email: speaker_email, bio: bio}
      if country 
        args[:country] = country
      end
      if city 
        args[:city] = city
      end
      puts args
      if dont_send
        result = args
        # hack to make changed emails stop showing up in airmeet diffs
        args[:email] = person.primary_email.email
      else
        result = create_speaker(args)
      end
      puts result
      newly_created = result["status"] == "SPEAKER_CREATED" || dont_send
      person.update({integrations: person.integrations.merge({airmeet: (person.integrations["airmeet"] || {}).merge({speaker_email: speaker_email, synced: newly_created || (person.integrations["airmeet"] || {})["synced"], data: newly_created ? args :  (person.integrations["airmeet"] || {})["data"], synced_at: newly_created ? Time.now.iso8601 : (person.integrations["airmeet"] || {})["synced_at"] })})})
    rescue
      p "ERROR with person #{person.primary_email&.email}. please check manually."
    end
  end

  def self.serialize_session(session) 
    begin
      args = {sessionTitle: "#{session.title} - #{session.format.name}",
        sessionSummary: ActionView::Base.full_sanitizer.sanitize(session.description),
        sessionDuration: session.duration,
        sessionStartTime: session.start_time,
        hostEmail: room_hosts[session.room_id]
      };
      participants = session.published_session_assignments.filter { |sa| (sa.session_assignment_role_type_id == moderator_id || sa.session_assignment_role_type_id == participant_id) && sa.person.registered }.map { |sa| sa.person }
      if session.environment == "virtual"
        args[:speakerEmails] = participants.map{|p| (p.integrations["airmeet"] || {})["speaker_email"] || p.primary_email&.email}
        args[:cohostEmails] = session.published_session_assignments.filter { |sa| sa.session_assignment_role_type_id == moderator_id && sa.person.registered }.map { |sa| (sa.person.integrations["airmeet"] || {})["speaker_email"] || sa.person.primary_email&.email }
      end
      if session.id === "e3e249ee-2800-40cc-a245-f462187833b9"
        args[:sessionTitle] = "Never Give Up, Never Surrender! The Art of Eric Wilkerson: Scifi Illustrator and Visual Afrofuturist"
      end
      args
    rescue => error
      Rails.logger.error(error)
      Rails.logger.error("Problem serializing session #{session}")
      {}
    end
  end

  def self.session_to_airmeet(session, dont_send = false)
    begin
      args = serialize_session(session);
      if args == {}
        p "ERROR with session #{session.title}. please check manually."
        return
      end
      participants = session.published_session_assignments.filter { |sa| (sa.session_assignment_role_type_id == moderator_id || sa.session_assignment_role_type_id == participant_id) && sa.person.registered }.map { |sa| sa.person }
      puts args
      if dont_send
        result = args
      else
        result = create_session(args);
      end
      puts result
      success = result["uid"] || dont_send
      old_airmeet_data = session.integrations["airmeet"] || {}
      session.update({integrations: session.integrations.merge({airmeet: {session_id: result["uid"] || old_airmeet_data["session_id"], synced: success || old_airmeet_data["synced"] , synced_at: success ? Time.now() : old_airmeet_data["synced_at"] , data: success ? args : old_airmeet_data["data"]}})})
      if session.environment == "virtual" && success && !dont_send
        people_tokens = (result["token"] || []).inject({}) {|p,c| p[c["email"]] = c["token"]; p}
        participants.each { |p| p.update({integrations: p.integrations.merge({airmeet: (p.integrations["airmeet"] || {}).merge({token: people_tokens[(p.integrations["airmeet"] || {})["speaker_email"]] || (p.integrations["airmeet"] || {})[:token]})})})}
      end
    rescue => error
      Rails.logger.error(error)
      p "ERROR with session #{session.title}. please check manually."
    end
  end

  def self.room_hosts
    @room_hosts ||= Room.where.not(integrations: {}).inject({}) { |p, c| p[c.id] = (c.integrations["airmeet"] || {})["room_host_email"]; p }
  end

  def self.virtual_people
    Person.left_outer_joins(:published_session_assignments, :published_sessions, :primary_email)
      .where(published_sessions: { environment: 'virtual' }, published_session_assignments: {session_assignment_role_type_id: [moderator_id, participant_id]})
      .distinct
  end

  def self.virtual_sessions 
    SessionService.published_sessions.where(streamed: true)
  end

  def self.moderator_id
    @moderator_id = SessionAssignmentRoleType.find_by(name: 'Moderator').id
  end

  def self.participant_id
    @participant_id = SessionAssignmentRoleType.find_by(name: 'Participant').id
  end

  def self.sync_to_airmeet
    virtual_people.map { |p| person_to_airmeet(p) }
    virtual_sessions.map { |s, | session_to_airmeet(s) }
    puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA IT WORKED"
  end

  def self.clear_room_hosts
    @room_hosts = nil
  end

  def self.clear_participant_data
    Person.where.not(integrations: {}).update_all(integrations: {})
  end

  def self.clear_session_data
    PublishedSession.where.not(integrations: {}).update_all(integrations: {})
  end

  class Airmeet
    include HTTParty
    base_uri "https://api-gateway.airmeet.com/prod"
    
    headers 'Content-Type' => 'application/json' 

    # TODO fix me to be based on environment
    default_options.update(verify: false)

    def auth
      self.class.post("/auth", {
        headers: {
          "X-Airmeet-Access-Key": ENV["AIRMEET_ACCESS_KEY"],
          "X-Airmeet-Secret-Key": ENV["AIRMEET_SECRET_KEY"],
          "X-Airmeet-Access-Token": ""
        },
        verify: false
      })
    end

    headers 'X-Airmeet-Access-Token' => AirmeetApiService.token
  end
  
end
