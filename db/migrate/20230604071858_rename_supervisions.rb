class RenameSupervisions < ActiveRecord::Migration[7.0]
  def change
    rename_table :supervisions, :relationships
    rename_column :topics, :supervision_id, :relationship_id
  end
end
