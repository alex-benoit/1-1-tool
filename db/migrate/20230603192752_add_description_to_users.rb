# frozen_string_literal: true

class AddDescriptionToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :description, :text
  end
end
