# frozen_string_literal: true

class SupervisionsController < ApplicationController
  def show
    @supervision = Supervision.find(params[:id])
    authorize @supervision
  end

  def new
    @supervision = Supervision.new
  end

  def create
    manager = find_or_create(email: supervision_params[:manager])
    direct_report = find_or_create(email: supervision_params[:direct_report])

    Supervision.create(manager:, direct_report:)

    redirect_to settings_path
  end

  private

  def supervision_params
    params.require(:supervision).permit(:manager, :direct_report)
  end

  def find_or_create(email:)
    User.find_by(email:) || User.create(email:, password: SecureRandom.alphanumeric(12))
  end
end
