class CreateWidgets < ActiveRecord::Migration[7.0]
  def change
    create_table :widgets do |t|
      t.bigint :user_id

      t.timestamps
    end
  end
end
