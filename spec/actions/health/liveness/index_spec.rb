# frozen_string_literal: true

RSpec.describe Certman::Actions::Health::Liveness::Index do
  let(:params) { {} }

  it "works" do
    response = subject.call(params)
    expect(response).to be_successful
    expect(response.format).to eq(:json)
    expect(response.body).to eq(
      [{"status" => "ok"}.to_json]
    )
  end
end
