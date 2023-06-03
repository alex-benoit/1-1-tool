# frozen_string_literal: true

class CreatePriorities < ActiveRecord::Migration[7.0]
  def change
    create_table :priorities do |t|
      t.string :title
      t.datetime :completed_at
      t.datetime :archived_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
