class CreateOrganizationLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :organization_locations do |t|
      t.integer :number
      t.bigint :organization_id

      t.timestamps
    end
  end
end
