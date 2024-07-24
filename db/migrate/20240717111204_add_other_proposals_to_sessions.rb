class AddOtherProposalsToSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :sessions, :other_proposals, :string, default: ''
  end
end
