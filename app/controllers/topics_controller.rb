# frozen_string_literal: true

class TopicsController < ApplicationController
  before_action :set_relationship

  def update
    topic = @relationship.topics.find(params[:id])
    topic.update(completed_at: params[:topic][:completed] == '1' ? Time.zone.now : nil)

    head :ok
  end

  def destroy
    @topic = @relationship.topics.find(params[:id])
    @topic.destroy
  end

  private

  def set_relationship
    @relationship = current_user.all_relationships.find(params[:relationship_id])
  end
end
