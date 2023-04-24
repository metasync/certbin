# frozen_string_literal: true

RSpec.describe 'GET /health/liveness', type: :request do
  it 'is successful' do
    get '/health/liveness'

    # Find me in `config/routes.rb`
    expect(last_response).to be_successful
    expect(last_response.content_type).to eq('application/json; charset=utf-8')

    response_body = JSON.parse(last_response.body)

    expect(response_body).to eq(
      { 'status' => 'ok' }
    )
  end
end
