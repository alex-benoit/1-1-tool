class CreateFeedbackConversations < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :feedback_conversation, :jsonb
  end
end
