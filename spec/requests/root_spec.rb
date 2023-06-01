# frozen_string_literal: true

RSpec.describe 'Root', type: :request do
  it 'is successful' do
    get '/'

    # Find me in `config/routes.rb`
    expect(last_response).to be_successful
    expect(last_response.body).to eq("Weclome to Certbin version #{Certbin::App::VERSION}")
  end
end
