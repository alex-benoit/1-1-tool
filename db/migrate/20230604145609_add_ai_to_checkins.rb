class AddAiToCheckins < ActiveRecord::Migration[7.0]
  def change
    add_column :checkins, :summary, :text
    add_column :checkins, :past_week_prompt, :string
    add_column :checkins, :coming_week_prompt, :string

    change_column_null :topics, :author_id, true
    add_column :topics, :ai_suggested, :boolean, default: false
  end
end
