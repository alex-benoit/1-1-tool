# frozen_string_literal: true

class Supervision < ApplicationRecord
  belongs_to :manager, class_name: 'User'
  belongs_to :direct_report, class_name: 'User'
end
