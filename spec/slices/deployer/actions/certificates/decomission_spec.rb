# frozen_string_literal: true

RSpec.describe Deployer::Actions::Certificates::Decomission do
  let(:params) { Hash[] }

  it 'works' do
    response = subject.call(params)
    expect(response).to be_successful
  end
end
