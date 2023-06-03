# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :direct_report_supervisions, class_name: 'Supervision', foreign_key: 'manager_id', dependent: :destroy
  has_many :direct_reports, through: :direct_report_supervisions

  has_many :manager_supervisions, class_name: 'Supervision', foreign_key: 'direct_report_id', dependent: :destroy
  has_many :managers, through: :manager_supervisions

  has_many :priorities, dependent: :destroy
end
