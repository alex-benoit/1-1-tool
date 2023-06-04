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
    direct_report = find_or_create(email: supervision_params[:user][:email])
    direct_report.update!(supervision_params[:user])

    current_user.direct_report_supervisions.create!(direct_report:)

    redirect_to root_path
  end

  private

  def supervision_params
    params.require(:supervision).permit(user: %i[name email description])
  end

  def find_or_create(email:)
    user = User.find_by(email:)
    if user
      user.update(supervision_params[:user])
    else
      User.create(supervision_params[:user].merge(password: SecureRandom.alphanumeric(12)))
    end
  end
end
