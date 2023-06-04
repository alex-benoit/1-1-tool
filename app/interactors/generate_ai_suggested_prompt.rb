# frozen_string_literal: true

class GenerateAiSuggestedPrompt
  include Interactor

  def call
    suggestions = openai_service.generate_duologue_prompts(context.checkin)

    context.checkin.update(
      summary: suggestions['summary'],
      past_week_prompt: suggestions['past'],
      coming_week_prompt: suggestions['coming']
    )

    suggestions['additional_talking_points'].each do |suggested_talking_points|
      context.checkin.user.manager_relationships.each do |relationship|
        relationship.topics.create(title: suggested_talking_points, ai_suggested: true)
      end
    end
  end

  private

  def openai_service
    OpenaiService.new
  end
end
