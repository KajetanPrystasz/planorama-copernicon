class AddCustomPublishedNameToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :custom_published_name, :string
    add_column :people, :custom_published_name_sort_by, :string
    add_column :people, :custom_published_name_sort_by_confirmed, :boolean, default: false
  end
end
