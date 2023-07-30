# frozen_string_literal: true

require 'dry/effects'

module Certbin
  module Middleware
    module Warden
      Auth = Dry::Effects.Reader(:auth)
    end
  end
end
