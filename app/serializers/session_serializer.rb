class SessionSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :title, :description,
             :duration, :minimum_people, :maximum_people,
             :item_notes, :pub_reference_number, :audience_size,
             :participant_notes, :is_break, :start_time,
             :visibility, :publish,
             :open_for_interest, :instructions_for_interest,
             :require_signup, :waiting_list_size,
             :updated_by, :interest_opened_by, :interest_opened_at,
             :room_id, :proofed, :format_id, :room_set_id,
             :status, :environment,
             :tech_notes, :room_notes,
             :minors_participation, :age_restriction_id,
             :recorded, :streamed

  # tag_list
  attribute :tag_list do |session|
    session.base_tags.collect(&:name)
  end

  attribute :area_list do |session|
    session.areas.collect(&:name).sort{ |a, b| a.downcase <=> b.downcase }
  end

  attribute :duration_mins do |session|
    session.duration
  end

  # session_areas
  attribute :session_areas_attributes do |session|
    session.session_areas
  end

  attribute :end_time do |session|
    (session.start_time && session.duration) ? session.start_time + session.duration.minutes : nil
  end

  attribute :has_conflicts do |session|
    if session.has_attribute?(:conflict_count)
      session.conflict_count > 0
    else
      (session.session_conflicts.count > 0) || (session.conflict_sessions.count > 0)
    end
  end

  has_many :session_areas, lazy_load_data: true, serializer: SessionAreaSerializer,
          links: {
            self: -> (object, params) {
              "#{params[:domain]}/session/#{object.id}"
            },
            related: -> (object, params) {
              "#{params[:domain]}/session/#{object.id}/session_areas"
            }
          }

  has_many :session_assignments, lazy_load_data: true, serializer: SessionAssignmentSerializer,
           links: {
             self: -> (object, params) {
               "#{params[:domain]}/session/#{object.id}"
             },
             related: -> (object, params) {
               "#{params[:domain]}/session/#{object.id}/session_assignments"
             }
           }

  has_many :participant_assignments, lazy_load_data: true, serializer: SessionAssignmentSerializer

  has_one :format,
          if: Proc.new { |record| record.format_id },
          links: {
            self: -> (object, params) {
              "#{params[:domain]}/session/#{object.id}"
            },
            related: -> (object, params) {
              "#{params[:domain]}/format/#{object.format.id}"
            }
          }

  has_one :room_set, lazy_load_data: true,
          if: Proc.new { |record| record.room_set },
          links: {
            self: -> (object, params) {
              "#{params[:domain]}/session/#{object.id}"
            },
            related: -> (object, params) {
              "#{params[:domain]}/room_set/#{object.room_set_id}"
            }
          }

  has_one :room, lazy_load_data: true,
          if: Proc.new { |record| record.room },
          links: {
            self: -> (object, params) {
              "#{params[:domain]}/session/#{object.id}"
            },
            related: -> (object, params) {
              "#{params[:domain]}/room/#{object.room_id}"
            }
          }
end
