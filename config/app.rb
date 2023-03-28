# frozen_string_literal: true

require "hanami"

module Certman
  class App < Hanami::App
    VERSION = "0.1.0"

    config.actions.format :json
    config.middleware.use :body_parser, :json
  end
end
