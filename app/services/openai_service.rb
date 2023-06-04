# frozen_string_literal: true

class OpenaiService
  def initialize
    @openai_client = OpenAI::Client.new
    @new_relice_service = NewRelicService.new
  end

  def feedback_convo(user)
    response = @openai_client.chat(parameters: {
      model: 'gpt-4'
    }.merge(user.feedback_conversation))

    new_message = { role: 'assistant', content: response['choices'].first['message']['content'] }

    user.update(feedback_conversation: { messages: user.feedback_conversation['messages'].append(new_message) })
  end

  def generate_duologue_prompts(checkin)
    previous_checkin = checkin.previous_checkin

    prompt = <<~DOUBLE_QUOTED.strip
      You help team managers with 1:1s by suggesting topics to talk about.

      This past week: the direct report has rated their past week a: #{checkin.morale}/7#{" because of the reason: #{checkin.morale_comment}" if checkin.morale_comment?}#{" (last week they were a: #{previous_checkin.morale}/7 and over the last 2 months their average was a: #{checkin.user.average(:morale)}/7." if previous_checkin}#{" They are celebrating: #{checkin.wins}." if checkin.wins?}#{" This past week, the direct report's priorities were: #{previous_checkin.priorities.map { |priority| "#{priority.title} (#{priority.completed_at? ? 'completed' : 'not achieved'})" }.to_sentence} - they completed #{previous_checkin.priorities_completion_rate * 100}% of their priorities" if previous_checkin&.priorities&.any?}

      This coming week: the direct report has mentioned their workload is: #{workload_to_words(checkin.workload)}#{" (last week their workload was: #{workload_to_words(previous_checkin.workload)} and over the last 2 months their average was: #{workload_to_words(checkin.user.average(:workload))}" if previous_checkin}.#{" They are stuck on and need help with: #{checkin.blockers}." if checkin.blockers?}#{" This coming week, the direct report's priorities are: #{checkin.priorities.map(&:title).to_sentence}" if checkin.priorities.any?}

      The team manager and the direct report have a 1:1 coming up tomorrow. What is a summary of all this information the direct report has given (stick to the most important information for the manager and max 3 sentences)? What is the best question for the manager to ask the direct report in this 1:1 regarding this past week (max 1 sentence)? What is the best question for the manager to ask the direct report in this 1:1 regarding this coming week (max 1 sentence)? Considering all the information given and your understanding of great 1:1 topics that drive performance and engagement, what are 2 talking points that you think the manager and direct report should cover in their next 1:1 (write them in a clear and concise way)?

      Use the direct report's name: #{checkin.user.name}. Repond in the following json format: {"summary": "summary", "past": "suggested_question_about_past_week", "coming": "suggested_question_about_coming_week", "additional_talking_points": ["talking_point_1", "talking_point_2"]}
    DOUBLE_QUOTED

    JSON.parse(ask(prompt))
  end

  private

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

  def openai_chatgpt_params(prompt)
    {
      model: 'gpt-4',
      messages: [
        { role: 'system', content: 'You are Larsen. You help team managers improve their teams.' },
        { role: 'user', content: prompt }
      ]
    }
  end

  def workload_to_words(workload)
    case workload
    when 1..3.5
      'not enough work'
    when 3.5..4.5
      'just enough work'
    when 4.5..5.5
      'slightly too much work'
    when 5.5..7
      'too much work'
    end
  end
end
