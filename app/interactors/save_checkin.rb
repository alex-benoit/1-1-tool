# frozen_string_literal: true

class SaveCheckin
  include Interactor

  def call
    save_checkin
    mark_previous_priorities_as_complete
    save_priorities
    update_duologue_topics
  end

  private

  def save_checkin
    context.checkin = context.user.checkins.create(
      morale: context.checkin_params[:morale],
      morale_comment: context.checkin_params[:morale_comment],
      wins: context.checkin_params[:wins],
      blockers: context.checkin_params[:blockers],
      workload: context.checkin_params[:workload]
    )
  end

  def mark_previous_priorities_as_complete
    context.checkin_params[:previous_priorities_attributes]&.each do |id, attributes|
      context.checkin.previous_checkin.priorities.find(id).update(completed: attributes[:completed])
    end
  end

  def save_priorities
    context.checkin_params[:priorities_attributes]&.each do |_rand, attributes|
      context.checkin.priorities.create(title: attributes[:title])
    end
  end

  def update_duologue_topics
    context.checkin_params[:relationship]&.each do |id, topics_attributes|
      relationship = context.user.all_relationships.find(id)
      topics_attributes['topics_attributes']&.each do |_id, topic_attributes|
        create_of_update_topic(relationship, topic_attributes)
      end
    end
  end

  def create_of_update_topic(relationship, params)
    if params[:id].present?
      topic = relationship.topics.find(params[:id])
      if params[:_destroy] == '1'
        topic.update(archived_at: Time.zone.now)
      else
        topic.update(title: params[:title])
      end
    else
      relationship.topics.create(title: params[:title], author: context.user)
    end
  end
end
