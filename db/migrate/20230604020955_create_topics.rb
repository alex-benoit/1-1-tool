class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics do |t|
      t.string :title
      t.references :supervision, null: false, foreign_key: true
      t.datetime :completed_at
      t.datetime :archived_at
      t.references :author, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
