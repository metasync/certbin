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

  it 'is failed when db connection is lost' do
    allow_any_instance_of(Certbin::Operations::CheckDatabaseConnection).to(
      receive(:call).and_return(false)
    )

    get '/health/liveness'

    expect(last_response.status).to eq(503) # service unavailable
    expect(last_response.content_type).to eq('application/json; charset=utf-8')

    response_body = JSON.parse(last_response.body)
    expect(response_body).to eq(
      { 'database' => 'Connection is lost.' }
    )
  end
end
