class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :name, null: false
      t.text :details, null: false

      t.timestamps null: false
    end
  end
end
