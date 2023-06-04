# frozen_string_literal: true

class Checkin < ApplicationRecord
  belongs_to :user

  has_many :priorities, dependent: :destroy

  def previous_checkin
    user.checkins.where('created_at < ?', created_at).last
  end
end
