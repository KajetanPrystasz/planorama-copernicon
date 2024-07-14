class AddColumnsToSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :sessions, :format_description, :text, default: ''
    add_column :sessions, :rpg_system, :string, null: true
    add_column :sessions, :rpg_knowledge_needed, :boolean, null: true
    add_column :sessions, :rpg_for_beginners, :boolean, null: true
    add_column :sessions, :rpg_number_of_players, :string, null: true
    add_column :sessions, :rpg_hardness, :text, null: true
    add_column :sessions, :team_size, :string, null: true
    add_column :sessions, :content_warning, :string, limit: 1000, default: ''
    add_column :sessions, :age_restrictions, :string, default: ''
    add_column :sessions, :accessibility, :string, limit: 1000, default: ''
    add_column :sessions, :nope_acknowledgment, :boolean, default: false
    add_column :sessions, :unavailable_10_11, :string, limit: 100, null: true
    add_column :sessions, :unavailable_11_12, :string, limit: 100, null: true
    add_column :sessions, :unavailable_12_13, :string, limit: 100, null: true
    add_column :sessions, :unavailable_13_14, :string, limit: 100, null: true
    add_column :sessions, :unavailable_14_15, :string, limit: 100, null: true
    add_column :sessions, :unavailable_15_16, :string, limit: 100, null: true
    add_column :sessions, :unavailable_16_17, :string, limit: 100, null: true
    add_column :sessions, :unavailable_17_18, :string, limit: 100, null: true
    add_column :sessions, :unavailable_18_19, :string, limit: 100, null: true
    add_column :sessions, :unavailable_19_20, :string, limit: 100, null: true
    add_column :sessions, :unavailable_20_21, :string, limit: 100, null: true
    add_column :sessions, :unavailable_21_22, :string, limit: 100, null: true
    add_column :sessions, :unavailability_notes, :string, limit: 500, default: ''
    add_column :sessions, :is_reused, :text, default: ''
    add_column :sessions, :experience, :string, limit: 500, default: ''
    add_column :sessions, :fandom_organization, :string, limit: 100, null: true
    add_column :sessions, :open_for_panel_participation, :text, default: ''
    add_column :sessions, :streaming_allowed, :boolean, default: false
    add_column :sessions, :abstract_url, :string, null: true
  end
end
