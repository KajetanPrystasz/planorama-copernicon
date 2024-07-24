class SessionsController < ResourceController
  SERIALIZER_CLASS = 'SessionSerializer'.freeze
  POLICY_CLASS = 'SessionPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SessionPolicy::Scope'.freeze
  # DEFAULT_SORTBY = 'name_sort_by'

  def schedule_publish
    authorize current_person, policy_class: policy_class

    PublicationService.start_publish_job

    render status: :ok, json: {}.to_json, content_type: 'application/json'
  end

  def has_open_for_interest
    authorize current_person, policy_class: policy_class
      render json: {open_for_interest: Session.where(open_for_interest: true).count() > 0}
    end

  # Mass update for the sessions (given ids and params)
  def update_all
    authorize current_person, policy_class: policy_class
    ids = params[:ids]
    attrs = params.permit(attrs: {})[:attrs].to_h #permit(:attrs)

    Session.transaction do
      # Get all the people with given set of ids and update them
      people = Session.where(id: ids).update(attrs)

      # return the updated people back to the caller
      options = {
        include: serializer_includes,
        params: {
          domain: "#{request.base_url}",
          current_person: current_person
        }
      }

      render json: serializer_class.new(people,options).serializable_hash(),
             content_type: 'application/json'
    end
  end

  def express_interest
    # create a session assignment if there is not already one
    model_class.transaction do
      authorize @object, policy_class: policy_class

      # Find or create the session assignment
      # needs to change ....
      person = Person.find params[:person_id] if params[:person_id]
      person ||= current_person

      assignment = @object.session_assignments.for_person(person.id).first
      if assignment
        assignment.interested = true
        assignment.save!
      else
        assignment = SessionAssignment.create(
          person: person,
          session: @object,
          interested: true
        )
      end

      render_object(
        assignment,
        serializer: SessionAssignmentSerializer,
        jsonapi_included: []
      )
    end
  end

  # Import sessions from a sheet
  def import
    authorize current_person, policy_class: policy_class

    sheet = params[:sheet]
    ignore_first_line = params[:ignore_first_line]
    count = 0
    person_count = 0
    sheet_length = sheet.length
    errored_rows = []
    current_row_nbr = -1
    no_title = 0
    duplicate_session = 0
    sheet.each do |row|
      current_row_nbr += 1
      if ignore_first_line && count == 0
        count += 1
        next
      end
      if row[0].to_s.strip == ''
        sheet_length -= 1
        next
      end

      row = row.map(&:to_s).map(&:strip)

      to_bool = -> (value, truthy_value = 'tak') {
        value.downcase == truthy_value
      }

      to_nil = -> (value, &closure) {
        if value.to_s == ''
          nil
        else
          (closure.nil? ? value : closure.call(value))
        end
      }

      excel_to_datetime = -> (value) {
        base_date = DateTime.new(1900, 1, 1)
        value_adjusted = value.to_f - 2
        
        base_date + value_adjusted - 2.0 / 24
      }

      # Person

      email_address = row[1]
      name = row[2]
      surname = row[3]
      pseudonym = row[4]
      published_name = row[5]
      of_age_at_convention_time = to_bool.call(row[6], 'Tak, będę mieć ukończone 18 lat.'.downcase)
      phone_number = row[7]

      person = Person.transaction do
        email_record = EmailAddress.find_by(email: email_address)
        if email_record && email_record.person
          email_record.person
        else
          new_person = Person.create(
            name: name,
            name_sort_by: name,
            surname: surname,
            surname_sort_by: surname,
            pseudonym: pseudonym,
            pseudonym_sort_by: pseudonym,
            custom_published_name: published_name,
            custom_published_name_sort_by: published_name,
            of_age_at_convention_time: of_age_at_convention_time,
            phone_number: phone_number
          )
          email = EmailAddress.create(
            person: new_person,
            email: email_address,
            isdefault: true,
            is_valid: true
          )
          ConventionRole.create!(
            person: new_person,
            role: ConventionRole.roles[:participant]
          )

          person_count += 1
          new_person
        end
      end

      # Session

      created_at = excel_to_datetime.call(row[0])
      participant_notes = row[8]
      area = Area.find_by(name: row[9])
      format_description = row[10]
      format = Format.find_by(name: format_description)
      title = row[11]
      description = row[12]
      duration = row[13].to_i
      rpg_system = to_nil.call(row[14])
      rpg_knowledge_needed = to_nil.call(row[15], &to_bool)
      rpg_for_beginners = to_nil.call(row[16], &to_bool)
      rpg_number_of_players = to_nil.call(row[17])
      rpg_hardness = to_nil.call(row[18])
      instructions_for_interest = to_nil.call(row[19])
      team_size = to_nil.call(row[20])
      tech_notes = to_nil.call(row[21])
      content_warning = row[22]
      age_restrictions = row[23]
      accessibility = row[24]
      unavailable_10_11 = to_nil.call(row[26])
      unavailable_11_12 = to_nil.call(row[27])
      unavailable_12_13 = to_nil.call(row[28])
      unavailable_13_14 = to_nil.call(row[29])
      unavailable_14_15 = to_nil.call(row[30])
      unavailable_15_16 = to_nil.call(row[31])
      unavailable_16_17 = to_nil.call(row[32])
      unavailable_17_18 = to_nil.call(row[33])
      unavailable_18_19 = to_nil.call(row[34])
      unavailable_19_20 = to_nil.call(row[35])
      unavailable_20_21 = to_nil.call(row[36])
      unavailable_21_22 = to_nil.call(row[37])
      unavailability_notes = row[38]
      is_reused = row[39]
      experience = row[40]
      fandom_organization = to_nil.call(row[41])
      open_for_panel_participation = row[42]
      streaming_allowed = to_bool.call(row[43])
      abstract_url = to_nil.call(row[44])
      other_proposals = row[46]

      if title && (title.length > 0)
        if Session.find_by title: title
          errored_rows << current_row_nbr
          duplicate_session += 1
          next
        end

        Session.transaction do
          session = Session.create(
            title: title,
            description: description,
            areas: [area],
            format: format,
            format_description: format_description,
            duration: duration,
            participant_notes: participant_notes,
            rpg_system: rpg_system,
            rpg_knowledge_needed: rpg_knowledge_needed,
            rpg_for_beginners: rpg_for_beginners,
            rpg_number_of_players: rpg_number_of_players,
            rpg_hardness: rpg_hardness,
            instructions_for_interest: instructions_for_interest,
            team_size: team_size,
            tech_notes: tech_notes,
            content_warning: content_warning,
            age_restrictions: age_restrictions,
            accessibility: accessibility,
            unavailable_10_11: unavailable_10_11,
            unavailable_11_12: unavailable_11_12,
            unavailable_12_13: unavailable_12_13,
            unavailable_13_14: unavailable_13_14,
            unavailable_14_15: unavailable_14_15,
            unavailable_15_16: unavailable_15_16,
            unavailable_16_17: unavailable_16_17,
            unavailable_17_18: unavailable_17_18,
            unavailable_18_19: unavailable_18_19,
            unavailable_19_20: unavailable_19_20,
            unavailable_20_21: unavailable_20_21,
            unavailable_21_22: unavailable_21_22,
            unavailability_notes: unavailability_notes,
            is_reused: is_reused,
            experience: experience,
            fandom_organization: fandom_organization,
            open_for_panel_participation: open_for_panel_participation,
            streaming_allowed: streaming_allowed,
            abstract_url: abstract_url,
            created_at: created_at,
            other_proposals: other_proposals
          )
          role = SessionAssignmentRoleType.find_by(name: 'Participant')
          SessionAssignment.create!(
            person: person,
            session: session,
            session_assignment_role_type: role
          )
          count += 1
        end
      else
        errored_rows << current_row_nbr
        no_title += 1
      end

      # Rails.logger.debug("***** ROW #{row}")
      # Rails.logger.debug("***** ROW #{row[4]} - #{row[5]}")
    end

    count = count - 1 if ignore_first_line
    Rails.logger.debug("Imported #{person_count} people, #{count} sessions, skipped #{sheet_length - count}.")

    message = {
      imported: "#{count}",
      skipped: "#{sheet_length - count}",
      no_title: "#{no_title}",
      duplicate_session: "#{duplicate_session}",
      other: "",
      errored_rows: errored_rows
    }


    render status: :ok,
           json: { message: message }.to_json,
           content_type: 'application/json'
  end

  def tags
    res = Session.tags_on(:tags).order(:name)

    render json: TagSerializer.new(res,
                  {
                    # include: serializer_includes,
                    params: {domain: "#{request.base_url}"}
                  }
                ).serializable_hash(),
           content_type: 'application/json'
  end

  def labels
    res = Session.tags_on(:labels).order(:name)

    render json: TagSerializer.new(res,
      {
        # include: serializer_includes,
        params: {domain: "#{request.base_url}"}
      }
    ).serializable_hash(),
    content_type: 'application/json'
  end

  def before_update
    # if time or room have changed removed ignored conflicts
    p = _permitted_params(model: object_name, instance: @object)
    if (@object.start_time || @object.room_id)
      if (p.has_key?('start_time') && p['start_time'] != @object.start_time) ||
          (p.has_key?('room_id') && p['room_id'] != @object.room_id)
        # so we remove any ignore conflicts for this session
        cids = @object.ignored_session_conflicts.pluck(:conflict_id)
        cids += @object.ignored_conflict_sessions.pluck(:conflict_id)
        IgnoredConflict.where(conflict_id: cids).delete_all
      end
    end
  end

  def serializer_includes
    [
      :format,
      :room,
      :room_set,
      :session_areas,
      :'session_areas.area'
      # Do not include assignment in the JSON by default as that can slow client down,
      # let client request them when needed
      # :session_assignments
    ]
  end

  def includes
    [
      :format,
      :room
    ]
  end

  def references
    [
      :format,
      :room
    ]
  end

  def eager_load
    [
      {session_areas: :area},
      :areas,
      :published_session,
      {taggings: :tag}
    ]
  end

  def array_col?(col_name:)
    return true if col_name == 'area_list'
    return true if col_name == 'tags_array'
    return true if col_name == 'labels_array'
    false
  end

  def array_table(col_name:)
    return 'areas_list' if col_name == 'area_list'
    return 'tags_list_table' if col_name == 'tags_array'
    return 'labels_list_table' if col_name == 'labels_array'
    false
  end

  def join_tables
    sessions = Arel::Table.new(Session.table_name)

    subquery = Session.area_list.as('areas_list')
    tags_subquery = Session.tags_list_table.as('tags_list_table')
    labels_subquery = Session.labels_list_table.as('labels_list_table')
    conflict_counts = Session.conflict_counts.as('conflict_counts')
    joins = [
      sessions.create_join(
        subquery,
        sessions.create_on(
          subquery[:session_id].eq(sessions[:id])
        ),
        Arel::Nodes::OuterJoin
      ),
      sessions.create_join(
        tags_subquery,
        sessions.create_on(
          tags_subquery[:session_id].eq(sessions[:id])
        ),
        Arel::Nodes::OuterJoin
      ),
      sessions.create_join(
        labels_subquery,
        sessions.create_on(
          labels_subquery[:session_id].eq(sessions[:id])
        ),
        Arel::Nodes::OuterJoin
      ),
      sessions.create_join(
        conflict_counts,
        sessions.create_on(
          conflict_counts[:session_id].eq(sessions[:id])
        )
      )
    ]

    if @filters
      tags = Arel::Table.new(ActsAsTaggableOn::Tag.table_name)
      taggings = Arel::Table.new(ActsAsTaggableOn::Tagging.table_name)

      joins += [
        sessions.create_join(
          taggings,
          sessions.create_on(
            sessions[:id].eq(taggings[:taggable_id]).and(
              taggings[:taggable_type].eq('Session')
            )
          ),
          Arel::Nodes::OuterJoin
        ),
        taggings.create_join(
          tags,
          taggings.create_on(
            taggings[:tag_id].eq(tags[:id])
          ),
          Arel::Nodes::OuterJoin
        )
      ]
    end

    joins
  end

  def select_fields
    Session.select(
      ::Session.arel_table[Arel.star],
      'conflict_counts.conflict_count',
      'tags_list_table.tags_array',
      'labels_list_table.labels_array'
    )
  end

  def paginate
    !params[:perPage].blank?
  end

  def allowed_params
    %i[
      id
      lock_version
      format_id
      room_set_id
      title
      description
      duration
      minimum_people
      maximum_people
      item_notes
      tech_notes
      pub_reference_number
      audience_size
      participant_notes
      is_break
      start_time
      visibility
      publish
      room_id
      open_for_interest
      instructions_for_interest
      tag_list
      label_list
      session_areas_attributes
      areas
      proofed
      format_id
      status
      environment
      minors_participation
      require_signup
      age_restriction_id
      room_notes
      recorded
      streamed
      content_warning
      age_restrictions
      accessibility
      is_reused
      experience
      fandom_organization
      open_for_panel_participation
      streaming_allowed
      abstract_url
      other_proposals
      rpg_system
      rpg_knowledge_needed
      rpg_for_beginners
      rpg_number_of_players
      rpg_hardness
      unavailable_10_11
      unavailable_11_12
      unavailable_12_13
      unavailable_13_14
      unavailable_14_15
      unavailable_15_16
      unavailable_16_17
      unavailable_17_18
      unavailable_18_19
      unavailable_19_20
      unavailable_20_21
      unavailable_21_22
      unavailability_notes
    ]
  end
end
