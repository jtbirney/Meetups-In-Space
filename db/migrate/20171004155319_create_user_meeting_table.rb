class CreateUserMeetingTable < ActiveRecord::Migration
  def change
    create_table :user_meetings do |t|
      t.belongs_to :user, null: false
      t.belongs_to :meeting, null: false
    end
  end
end
