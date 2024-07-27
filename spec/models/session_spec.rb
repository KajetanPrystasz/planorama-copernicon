# == Schema Information
#
# Table name: sessions
#
#  id                        :uuid             not null, primary key
#  audience_size             :integer
#  description               :text
#  duration                  :integer
#  environment               :enum             default("unknown")
#  instructions_for_interest :text
#  interest_opened_at        :datetime
#  interest_opened_by        :string
#  is_break                  :boolean          default(FALSE)
#  item_notes                :text
#  lock_version              :integer          default(0)
#  maximum_people            :integer
#  minimum_people            :integer
#  minors_participation      :jsonb
#  open_for_interest         :boolean          default(FALSE)
#  participant_notes         :text
#  proofed                   :boolean          default(FALSE), not null
#  pub_reference_number      :integer
#  publish                   :boolean          default(FALSE), not null
#  recorded                  :boolean          default(FALSE), not null
#  require_signup            :boolean          default(FALSE)
#  room_notes                :text
#  short_title               :string(30)
#  start_time                :datetime
#  status                    :enum             default("draft")
#  streamed                  :boolean          default(FALSE), not null
#  tech_notes                :text
#  title                     :string(256)
#  updated_by                :string
#  visibility                :enum             default("is_public")
#  waiting_list_size         :integer          default(0)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  age_restriction_id        :uuid
#  format_id                 :uuid
#  room_id                   :uuid
#  room_set_id               :uuid
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
require 'rails_helper'

RSpec.describe Session, "#factories" do
  context "session factory" do
    it "creates a session" do
      session = create(:session)
      expect(session.format).to be_truthy
      expect(session).to_not be_published
      expect(session.people).to be_empty
      expect(session.session_assignments).to be_empty
      expect(session.duration).to be(60)
      expect(session.minimum_people).to be_nil
      expect(session.maximum_people).to be_nil
    end
  end

  context "panel factory" do
    it "creates a panel" do
      panel = create(:panel)
      expect(panel.title).to eq "a panel"
      expect(panel.format.name).to include "panel"
    end
  end

  context "session_with_participants factory" do
    it "creates a session with participants" do
      item = create(:session_with_participants)
      expect(item.people.length).to eq 5
    end
  end
end
