class CreateCheckins < ActiveRecord::Migration[7.0]
  def change
    create_table :checkins do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :morale
      t.string :morale_comment
      t.text :wins
      t.text :blockers
      t.integer :workload

      t.timestamps
    end
  end
end
