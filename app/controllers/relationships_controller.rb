# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def show
    @relationship = Relationship.find(params[:id])
    authorize @relationship

    @direct_report = @relationship.direct_report
    @latest_checkin = @direct_report.checkins.last
    @previous_checkin = @latest_checkin&.previous_checkin
  end

  def new
    @relationship = Relationship.new
    @direct_report = User.new
  end

  def create
    direct_report = find_or_create(email: relationship_params[:user][:email])
    Relationship.create(manager: current_user, direct_report:)

    redirect_to root_path
  end

  def feedback_chat

  end

  private

  def relationship_params
    params.require(:relationship).permit(user: %i[name email description])
  end

  def find_or_create(email:)
    user = User.find_by(email:)
    if user
      user.update(relationship_params[:user])
    else
      User.create(relationship_params[:user].merge(password: SecureRandom.alphanumeric(12)))
    end
  end
end
