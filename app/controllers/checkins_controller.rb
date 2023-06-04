# frozen_string_literal: true

class CheckinsController < ApplicationController
  def new
    @checkin = Checkin.new
  end

  def create; end

  private

  def checkin_params
    params.require(:checkin).permit(:morale)
  end
end
