# frozen_string_literal: true

class NewRelicService
  INSIGHTS_URL = "https://insights-collector.newrelic.com/v1/accounts/#{ENV.fetch('NEWRELIC_ACCOUNT_NUMBER')}/events".freeze

  def track_event(event_name, params:)
    payload = { 'eventType' => event_name }.merge(params)

    insights_url = URI.parse(INSIGHTS_URL)
    headers = { 'Api-Key' => ENV.fetch('NEWRELIC_INGEST_KEY'), 'content-type' => 'application/json' }

    http = Net::HTTP.new(insights_url.host, insights_url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(insights_url.request_uri, headers)
    request.body = payload.to_json

    http.request(request)
  rescue Exception => e
    Rails.logger.debug { "There was an error posting to New Relic. Error: #{e.inspect}" }
  end
end
