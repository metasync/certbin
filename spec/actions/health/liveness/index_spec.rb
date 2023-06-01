# frozen_string_literal: true

RSpec.describe Certbin::Actions::Health::Liveness::Index do
  let(:params) { {} }

  it 'probes liveness' do
    response = subject.call(params)
    expect(response).to be_successful
    expect(response.format).to eq(:json)
    expect(response.body).to eq([{ 'status' => 'ok' }.to_json])
  end
end
