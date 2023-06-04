# frozen_string_literal: true

class RelationshipPolicy
  attr_reader :user, :relationship

  def initialize(user, relationship)
    @user = user
    @relationship = relationship
  end

  def show?
    relationship.manager == user || relationship.direct_report == user
  end
end
