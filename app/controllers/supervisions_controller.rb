# frozen_string_literal: true

class SupervisionsController < ApplicationController
  def show
    @supervision = Supervision.find(params[:id])
    authorize @supervision
  end

  def new
    @supervision = Supervision.new
    @direct_report = User.new
  end

  def create
    direct_report = User.find_or_create_by!(email: supervision_params[:user][:email])
    direct_report.update!(supervision_params[:user])

    current_user.direct_report_supervisions.create!(direct_report:)

    redirect_to root_path
  end

  private

  def supervision_params
    params.require(:supervision).permit(user: %i[name email description])
  end

  def find_or_create(email:)
    User.find_by(email:) || User.create(email:, password: SecureRandom.alphanumeric(12))
  end
end
