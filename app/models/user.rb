# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :direct_report_relationships, class_name: 'Relationship', foreign_key: 'manager_id', dependent: :destroy, inverse_of: :direct_report
  has_many :direct_reports, through: :direct_report_relationships

  has_many :manager_relationships, class_name: 'Relationship', foreign_key: 'direct_report_id', dependent: :destroy, inverse_of: :manager
  has_many :managers, through: :manager_relationships

  has_many :checkins, dependent: :destroy

  has_many :topics, dependent: :destroy, foreign_key: 'author_id', inverse_of: :author

  validates :name, :email, presence: true
end
