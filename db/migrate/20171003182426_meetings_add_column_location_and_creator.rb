class MeetingsAddColumnLocationAndCreator < ActiveRecord::Migration
  def change
    add_column :meetings, :location, :string
    add_column :meetings, :creator_id, :integer
  end
end
