# frozen_string_literal: true

class Relationship < ApplicationRecord
  belongs_to :manager, class_name: 'User'
  belongs_to :direct_report, class_name: 'User'

  has_many :topics, dependent: :destroy

  def open_topics
    topics.where(archived_at: nil, completed_at: 1.hour.ago..).or(topics.where(archived_at: nil, completed_at: nil))
  end
end
