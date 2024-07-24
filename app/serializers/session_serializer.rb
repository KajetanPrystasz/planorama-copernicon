# == Schema Information
#
# Table name: sessions
#
#  id                           :uuid             not null, primary key
#  abstract_url                 :string
#  accessibility                :string(1000)     default("")
#  age_restrictions             :string           default("")
#  audience_size                :integer
#  content_warning              :string(1000)     default("")
#  description                  :text
#  duration                     :integer
#  environment                  :enum             default("unknown")
#  experience                   :string(500)      default("")
#  fandom_organization          :string(100)
#  format_description           :text             default("")
#  instructions_for_interest    :text
#  interest_opened_at           :datetime
#  interest_opened_by           :string
#  is_break                     :boolean          default(FALSE)
#  is_reused                    :text             default("")
#  item_notes                   :text
#  lock_version                 :integer          default(0)
#  maximum_people               :integer
#  minimum_people               :integer
#  minors_participation         :jsonb
#  nope_acknowledgment          :boolean          default(FALSE)
#  open_for_interest            :boolean          default(FALSE)
#  open_for_panel_participation :text             default("")
#  other_proposals              :string           default("")
#  participant_notes            :text
#  proofed                      :boolean          default(FALSE), not null
#  pub_reference_number         :integer
#  publish                      :boolean          default(FALSE), not null
#  recorded                     :boolean          default(FALSE), not null
#  require_signup               :boolean          default(FALSE)
#  room_notes                   :text
#  rpg_for_beginners            :boolean
#  rpg_hardness                 :text
#  rpg_knowledge_needed         :boolean
#  rpg_number_of_players        :string
#  rpg_system                   :string
#  start_time                   :datetime
#  status                       :enum             default("draft")
#  streamed                     :boolean          default(FALSE), not null
#  streaming_allowed            :boolean          default(FALSE)
#  team_size                    :string
#  tech_notes                   :text
#  title                        :string(256)
#  unavailability_notes         :string(500)      default("")
#  unavailable_10_11            :string(100)
#  unavailable_11_12            :string(100)
#  unavailable_12_13            :string(100)
#  unavailable_13_14            :string(100)
#  unavailable_14_15            :string(100)
#  unavailable_15_16            :string(100)
#  unavailable_16_17            :string(100)
#  unavailable_17_18            :string(100)
#  unavailable_18_19            :string(100)
#  unavailable_19_20            :string(100)
#  unavailable_20_21            :string(100)
#  unavailable_21_22            :string(100)
#  updated_by                   :string
#  visibility                   :enum             default("is_public")
#  waiting_list_size            :integer          default(0)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  age_restriction_id           :uuid
#  format_id                    :uuid
#  room_id                      :uuid
#  room_set_id                  :uuid
#
# Indexes
#
#  index_sessions_on_description                (description) USING gin
#  index_sessions_on_instructions_for_interest  (instructions_for_interest) USING gin
#  index_sessions_on_interest_opened_by         (interest_opened_by) USING gin
#  index_sessions_on_item_notes                 (item_notes) USING gin
#  index_sessions_on_participant_notes          (participant_notes) USING gin
#  index_sessions_on_room_id                    (room_id)
#  index_sessions_on_room_notes                 (room_notes) USING gin
#  index_sessions_on_tech_notes                 (tech_notes) USING gin
#  index_sessions_on_title                      (title) USING gin
#  index_sessions_on_updated_by                 (updated_by) USING gin
#
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
             :recorded, :streamed,
             :format_description, :format_value,
             :rpg_system, :rpg_knowledge_needed, :rpg_for_beginners, :rpg_number_of_players, :rpg_hardness,
             :team_size, :content_warning, :age_restrictions, :accessibility,
             :nope_acknowledgment, :unavailable_10_11, :unavailable_11_12, :unavailable_12_13, :unavailable_13_14,
             :unavailable_14_15, :unavailable_15_16, :unavailable_16_17, :unavailable_17_18, :unavailable_18_19,
             :unavailable_19_20, :unavailable_20_21, :unavailable_21_22,:unavailability_notes,
             :is_reused, :experience, :fandom_organization, :open_for_panel_participation, :streaming_allowed,
             :abstract_url, :other_proposals, :solicitor_name, :solicitor_published_name

  # NOTE: session.tag_list would work, but if we prefetch taggings and tags this is faster (less DB queries)
  attribute :tag_list do |session|
    session.taggings.select{|t| t.context == 'tags'}.collect(&:tag).collect(&:name)
  end

  attribute :label_list do |session|
    session.taggings.select{|t| t.context == 'labels'}.collect(&:tag).collect(&:name)
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

  attribute :is_published do |session|
    session.published?
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
