module MailService

  # Person status changes
  # Potential Invite, Volunteered, Invite Pending, Invited
  # Unknown, Probable, Accepted, Declined - invitation set after filling in Program Survey (need to indicate which survey)

  # There are multiple types of emails

  # 1. Invite a person to fill in a survey
  # - need to create a survey respondent if there is not already one (for the key for authentication)
  # - set the state of the person to invited? (this should be an option on the state)
  # 2. Schedule confirmation
  # 3. Completed survey - thank you email
  # 4. Informational email

  # TODO - add variable to the survey template to say what state the person's acceptance status should be after they complete the survey
  # QUESTION - should we do this for the invite status as well?

  # def self.send_email(person, mail_use, survey = nil, respondentDetails = nil)
  #   if survey
  #     template = MailTemplate.unscoped.where(["mail_use_id = ?",mail_use.id]).first
  #   else
  #     template = MailTemplate.where(["mail_use_id = ?",mail_use.id]).first
  #   end
  #
  #   raise "can not find a template for the email" if !template
  #
  #   to_invite_status = template.transiton_invite_status
  #
  #   to = person.getDefaultEmail.email
  #   if to && !to.blank?
  #     content = generate_email_content(template, {
  #       :person             => person,
  #       :survey             => survey,
  #       :respondentDetails  => respondentDetails
  #     })
  #     begin
  #       PlannerMailer.send_email(
  #         {
  #           to:       to,
  #           subject:  template.subject,
  #           title:    template.title,
  #           return_path: parameter_value('email_from_address'),
  #           skip_premailer: true,
  #           content_type: "text/html",
  #           body: content
  #         }, content
  #       ).deliver_later
  #
  #       save_mail_history(person, nil, content, EmailStatus[:Sent], template.subject)
  #       transition_person_invite_status_after_email(person, to_invite_status) if to_invite_status
  #     rescue => msg
  #       save_mail_history(person, nil, msg, EmailStatus[:Failed], template.subject)
  #     end
  #   end
  # end

  # def self.transition_person_invite_status_after_email(person, to_status)
  #   person.invitestatus = to_status
  #   person.save!
  # end

  # Generate the email given the template and the args
  # def self.send_email_for_mailing(person, mailing, base_url, test_address: nil, send_test: false)
  #   raise "can not find a template for the email" unless mailing.mail_template
  #
  #   to_invite_status = mailing.mail_template.transiton_invite_status
  #
  #   if (send_test && test_address.present?) || (person.getDefaultEmail && person.getDefaultEmail.email.present?)
  #     to = send_test ? test_address : person.getDefaultEmail.email
  #
  #     if to.present?
  #       cc = ""
  #
  #       if !send_test && mailing.cc_all
  #         # add all the email addresses for the person to the CC
  #         person.email_addresses.each do |addr|
  #           if addr.email != to
  #             cc += ", " if !cc.blank?
  #             cc += addr.email
  #           end
  #         end
  #       end
  #
  #       # assignments = mailing.mail_template ? ProgramItemsService.findProgramItemsForPerson(person) : nil
  #       assignments = mailing.mail_template ? ScheduleEntry.where(person_id: person.id) : nil
  #       respondentDetails = person.survey_respondent
  #       key = respondentDetails && !respondentDetails.key.blank? ? respondentDetails.key : generate_survey_key(person) # get the key (or generate it)
  #       survey = mailing.mail_template && mailing.mail_template.survey ? mailing.mail_template.survey : nil
  #
  #       content = generate_email_content(
  #         mailing.mail_template,
  #         {
  #           :person             => person,
  #           :key                => key,
  #           :survey             => survey,
  #           :survey_url         => (base_url && survey) ? (base_url + '/form/' + survey.alias) : '',
  #           :respondentDetails  => person.survey_respondent,
  #           :assignments        => person
  #         },
  #         {
  #           title: mailing.mail_template.subject.blank? ? mailing.mail_template.title : mailing.mail_template.subject,
  #           batch: mailing.mailing_number.to_s
  #           # add in organization and conference?
  #         }
  #       )
  #
  #       begin
  #         subject = mailing.mail_template.subject
  #
  #         PlannerMailer.send_email(
  #           {
  #             from:     mailing.from_address,
  #             reply_to: parameter_value('email_reply_to_address'),
  #             to:       to,
  #             cc:       cc,
  #             subject:  subject,
  #             title:    mailing.mail_template.title,
  #             skip_premailer: true,
  #             content_type: "text/html",
  #             body: content
  #           }, content
  #         ).deliver_later
  #
  #         unless send_test
  #           save_mail_history(person, mailing, content, EmailStatus[:Sent], subject)
  #           transition_person_invite_status_after_email(person, to_invite_status) if to_invite_status
  #         end
  #       rescue Net::SMTPSyntaxError
  #       rescue Net::SMTPServerBusy => error
  #         # Recipient address rejected
  #         throw error unless error.message.include?('Recipient address rejected')
  #         save_mail_history(person, mailing, content, EmailStatus[:Failed], subject)
  #       rescue EOFError
  #         # this indicates that the email address is not valid
  #       rescue => msg
  #         # EOFError
  #         throw msg
  #         # THROW ERROR ??? - this would cause a retry of the whole list, which would be an issue for dups
  #         # do not do a retry unless we can resume from the failed message only
  #       end
  #     end
  #   end
  # end

  def self.send_mailing(
    person:,
    mailing:
  )
    content = self.generate_email_content(
      mailing.mail_template,
      {
        person: person,
        # survey: survey,
        # survey_url: (base_url && survey) ? (base_url + '/form/' + survey.alias) : '',
      }
    )

    self.send_email(
      to:             person.primary_email,
      subject:        mailing.mail_template.subject,
      title:          mailing.mail_template.title,
      content:        content
    )

    # TODO: transition person state? baaed on mailing and survey?
  end

  def self.send_email(from: nil, reply_to: nil, to:, cc: nil, subject:, title:, content:, person: nil, mailing: nil, skip_premailer: false)
    args = {
      subject:        subject,
      title:          title,
      content_type:   'text/html',
      body:           content
    }

    args[:from] = from if from
    args[:reply_to] = reply_to if reply_to
    args[:to] = to if to
    args[:cc] = cc if cc
    args[:skip_premailer] = skip_premailer if skip_premailer

    mail = ApplicationMailer.new.mail(args) #.deliver_now

    mail.deliver

    self.save_mail_history(
      person: person,
      email_status: MailHistory::email_statuses[:sent],
      mailing: mailing,
      mail: mail
    )
  rescue Net::SMTPSyntaxError
    # Rails.logger.debug "******** SMTP error"
    self.save_mail_history(
      person:       person,
      email_status: MailHistory.email_statuses[:failed],
      mailing:      mailing,
      mail: mail
    )
  rescue Net::SMTPServerBusy => error
    # Recipient address rejected
    raise unless error.message.include?('Recipient address rejected')

    self.save_mail_history(
      person:       person,
      email_status: MailHistory.email_statuses[:failed],
      mailing:      mailing,
      mail: mail
    )
  rescue EOFError
    # Rails.logger.debug "******** SMTP email invalid"
    # this indicates that the email address is not valid
    self.save_mail_history(
      person:       person,
      email_status: MailHistory.email_statuses[:failed],
      mailing:      mailing,
      mail: mail
    )
  rescue
    raise
    # do not do a retry unless we can resume from the failed message only
  end

  # TODO = move to mailer ???
  def self.save_mail_history(person:, email_status: MailHistory.email_statuses[:sent], mailing: nil, mail:)
    return unless mail

    mail_history = MailHistory.create(
      person:       person,
      mailing:      mailing,
      date_sent:    DateTime.now,
      email_status: email_status,
      testrun:      (mailing ? mailing.testrun : false),
      email:        mail.to,
      subject:      mail.subject,
      content:      mail.body.to_s
    )
  end

  # TODO - do we need this?
  # def self.get_magic_link(person)
  #   magic_link = generate_magic_link(person)
  #   magic_link
  # end

  # Given an email template and a set of argument generate the body for the email
  def self.generate_email_content(template, arguments)
    args = arguments

    # TODO: test
    return ERB.new(
      template.content,
      0, "%<>"
    ).result(binding) # pass in a context with the parameters i.e. ruby binding
  end
end
