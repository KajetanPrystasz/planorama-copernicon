class SessionsController < ResourceController
  SERIALIZER_CLASS = 'SessionSerializer'.freeze
  POLICY_CLASS = 'SessionPolicy'.freeze
  POLICY_SCOPE_CLASS = 'SessionPolicy::Scope'.freeze
  # DEFAULT_SORTBY = 'name_sort_by'

  # Import sessions from a sheet
  def import
    authorize current_person, policy_class: policy_class

    sheet = params[:sheet]
    ignore_first_line = params[:ignore_first_line]
    count = 0
    sheet_length = sheet.length
    Session.transaction do
      sheet.each do |row|
        if ignore_first_line && count == 0
          count += 1
          next
        end

        areas = row[0].split(",")
        title = row[1]
        description = row[2]
        # format = row[3]
        goh_notes = row[4]
        interest_open = row[5]
        interest_instructions = row[6]
        tags = row[7]
        notes = row[8]

        format = Format.find_or_create_by(name: row[3])

        if title && (title.length > 0)
          # Rails.logger.error "***** #{title}"
          # Rails.logger.error "***** #{notes} \n #{goh_notes}"
          session = Session.create!(
            title: title,
            description: description,
            open_for_interest: interest_open && interest_open == 'Yes',
            instructions_for_interest: interest_instructions,
            item_notes: [notes, goh_notes].join("\n").strip,
            format: format
          )

          # NOTE: we are not worried about tags as yet
          # tags

          primary = true
          areas.each do |area_name|
            area = Area.find_or_create_by(name: area_name)
            SessionArea.create!(
              session: session,
              area: area,
              primary: primary
            )
            primary = false
          end

          count += 1
        end
      end
    end

    count = count - 1 if ignore_first_line
    message = "Imported #{count} sessions, skipped #{sheet_length - count}"

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

  def serializer_includes
    [
      :format,
      :room,
      :session_areas,
      :session_assignments,
      :my_interest,
      :'session_areas.area'
    ]
  end

  def includes
    [
      :format,
      :room,
      :areas,
      :base_tags,
      :session_areas,
      :session_assignments
    ]
  end

  def references
    [
      :format,
      :room,
      :base_tags,
      :session_areas
    ]
  end

  def allowed_params
    %i[
      id
      lock_version
      format_id
      title
      description
      duration
      minimum_people
      maximum_people
      item_notes
      pub_reference_number
      audience_size,
      participant_notes
      is_break
      start_time,
      visibility
      publish
      room_id
      open_for_interest
      instructions_for_interest
      tag_list
      session_areas_attributes
    ]
    # Tags
    # format
    # areas
  end
end
