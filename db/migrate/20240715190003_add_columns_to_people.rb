class AddColumnsToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :of_age_at_convention_time, :boolean, default: false
    add_column :people, :phone_number, :string, limit: 100, default: ''
  end
end
