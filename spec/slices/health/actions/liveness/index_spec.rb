# frozen_string_literal: true

RSpec.describe Health::Actions::Liveness::Index do
  let(:params) { Hash[] }

  it 'probes health liveness' do
    response = subject.call(params)
    expect(response).to be_successful
    expect(response.format).to eq(:json)
    expect(response.body).to eq([{ 'status' => 'ok' }.to_json])
  end
end
