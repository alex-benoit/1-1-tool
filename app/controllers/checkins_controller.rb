# frozen_string_literal: true

class CheckinsController < ApplicationController
  def new
    @checkin = Checkin.new
  end

  def create
    result = SaveCheckin.call(user: current_user, checkin_params:)

    if result.success?
      redirect_to root_path, notice: 'Thank you!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def checkin_params
    params.require(:checkin).permit(:morale, :morale_comment, :wins, :blockers, :workload, previous_priorities_attributes: %i[completed], priorities_attributes: %i[title], relationship: [{ topics_attributes: %i[id title _destroy] }])
  end
end
