class AddSurnameToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :surname, :string
  end
end
