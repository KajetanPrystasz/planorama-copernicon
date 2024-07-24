class AddSurnameSortByToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :surname_sort_by, :string
    add_column :people, :surname_sort_by_confirmed, :boolean, default: false
  end
end
