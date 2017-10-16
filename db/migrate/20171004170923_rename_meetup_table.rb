class RenameMeetupTable < ActiveRecord::Migration
  def change
    rename_table :meetings, :meetups
    rename_table :user_meetings, :user_meetups
    rename_column :user_meetups, :meeting_id, :meetup_id
  end
end
