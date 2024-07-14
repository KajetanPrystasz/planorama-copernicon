class AddFullNameToPeople < ActiveRecord::Migration[6.1]
  def up
    Person.connection.execute("ALTER TABLE people ADD COLUMN full_name CHARACTER VARYING GENERATED ALWAYS AS (COALESCE(name, '') || ' ' || COALESCE(surname, '')) STORED")
  end

  def down
    change_table :people do |t|
      t.remove :full_name
    end
  end
end
