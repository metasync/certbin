# frozen_string_literal: true

require "hanami"
require_relative "version"

module Certman
  class App < Hanami::App
    config.actions.format :json
    config.middleware.use :body_parser, :json
  end
end
