# frozen_string_literal: true

RSpec.describe Requester::Actions::Certificates::Show do
  let(:params) { Hash[] }

  it 'works' do
    response = subject.call(params)
    expect(response).to be_successful
  end
end
