# frozen_string_literal: true

class SupervisionPolicy
  attr_reader :user, :supervision

  def initialize(user, supervision)
    @user = user
    @supervision = supervision
  end

  def show?
    supervision.manager == user || supervision.direct_report == user
  end
end
