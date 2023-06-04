class Topic < ApplicationRecord
  belongs_to :relationship
  belongs_to :author, class_name: 'User'
end
