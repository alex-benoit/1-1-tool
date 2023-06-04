# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :direct_report_relationships, class_name: 'Relationship', foreign_key: 'manager_id', dependent: :destroy, inverse_of: :direct_report
  has_many :manager_relationships, class_name: 'Relationship', foreign_key: 'direct_report_id', dependent: :destroy, inverse_of: :manager

  has_many :direct_reports, through: :manager_relationships
  has_many :managers, through: :direct_report_relationships

  has_many :checkins, dependent: :destroy

  has_many :topics, dependent: :destroy, foreign_key: 'author_id', inverse_of: :author

  validates :name, :email, presence: true

  def average(field)
    checkins.where(created_at: 2.months.ago..Time.zone.now).average(field).round(2)
  end

  def all_relationships
    Relationship.where(manager: self).or(Relationship.where(direct_report: self))
  end

  def set_init_convo
    update(feedback_conversation: {
      messages: [
        { role: 'system', content: 'You are having a conversation with a user to help them formulate feedback for their manager in the format from the book non-violent communication. Tell me when you have enough information to properly craft the feedback and send it to the user in a concise format.' },
        { role: 'assistant', content: 'Hi there! Anything on your mind you want to share with your manager. I can help formulate it to prep for your next 1:1' }
      ]
    })
  end
end
