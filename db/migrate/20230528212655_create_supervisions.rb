# frozen_string_literal: true

class CreateSupervisions < ActiveRecord::Migration[7.0]
  def change
    create_table :supervisions do |t|
      t.references :manager, null: false, foreign_key: { to_table: :users }
      t.references :direct_report, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :supervisions, %i[manager_id direct_report_id], unique: true
  end
end
