class AddPrioritiesToCheckins < ActiveRecord::Migration[7.0]
  def change
    add_reference :priorities, :checkin, index: true, foreign_key: true
    remove_reference :priorities, :user
  end
end
