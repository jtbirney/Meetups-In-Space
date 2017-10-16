class MoveCreatorToUserMeetups < ActiveRecord::Migration
  def change
    remove_column :meetups, :creator_id
    add_column :user_meetups, :creator, :boolean, default: false
  end
end
