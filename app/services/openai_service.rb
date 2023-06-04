# frozen_string_literal: true

class OpenaiService
  def initialize
    @openai_client = OpenAI::Client.new
    @new_relice_service = NewRelicService.new
  end

  def ask(prompt) # rubocop:disable Metrics/MethodLength
    api_params = openai_chatgpt_params(prompt)
    start_time = Time.zone.now
    response = @openai_client.chat(parameters: api_params)
    end_time = Time.zone.now

    @new_relice_service.track_event(
      'OpenAICompletion',
      params: {
        messages: prompt,
        response_time: end_time - start_time,
        'usage.total_tokens': response['usage']['total_tokens'],
        'usage.prompt_tokens': response['usage']['prompt_tokens'],
        'usage.completion_tokens': response['usage']['completion_tokens'],
        model: response['model'],
        'choices.0.message.content': response['choices'].first['message']['content']
      }
    )

    response['choices'].first['message']['content']
  end

  private

  def openai_chatgpt_params(prompt)
    {
      model: 'gpt-4',
      messages: [
        { role: 'system', content: 'You are Larsen. You help team managers improve their teams.' },
        { role: 'user', content: prompt }
      ]
    }
  end
end
