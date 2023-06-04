# frozen_string_literal: true

class FeedbackChatsController < ApplicationController
  def chat
    new_message = { role: 'user', content: params[:chat][:message] }
    current_user.update(feedback_conversation: { messages: current_user.feedback_conversation['messages'].append(new_message) })

    OpenaiService.new.feedback_convo(current_user)

    render partial: 'checkins/chat'
  end
end
