class ChangeAccessibilitySizeForPeople < ActiveRecord::Migration[6.1]
  def change
    change_column :sessions, :accessibility, :string, limit: 1000
  end
end
