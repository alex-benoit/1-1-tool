class NewRelicService
  def initialize
  end

  def track_openai_call
    payload = { 'eventType' => 'OpenAICompletion' }

    insights_url = URI.parse('https://insights-collector.newrelic.com/v1/accounts/3962793/events')
    headers = { 'Api-Key' => 'b1b9eaeed1b32fadcecc72ad43d9d41bfc20NRAL', 'content-type' => 'application/json' }

    http = Net::HTTP.new(insights_url.host, insights_url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(insights_url.request_uri, headers)
    request.body = payload.to_json

    puts "Sending run summary to New Relic: #{payload.to_json}"
    begin
      response = http.request(request)
      p response
      puts "Response from New Relic: #{response.body}"
    rescue Exception => e
      puts "There was an error posting to New Relic. Error: #{e.inspect}"
    end
  end
end
