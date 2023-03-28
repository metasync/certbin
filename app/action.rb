# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "rom"

module Certman
  class Action < Hanami::Action
    handle_exception ROM::TupleCountMismatchError => :handle_record_not_found

    before :validate_params

    def handle(request, response)
      result = handle_request(request)
      result[:error] ?
        on_error(result, response) :
        on_success(result, response)
    end

    protected

    def validate_params(request, response)
      unless request.params.valid?
        halt :unprocessable_entity, # 422
          request.params.errors.to_json
      end
    end

    def handle_record_not_found(request, response, exception)
      response.status = :not_found
      response.body = {error: "Certificate is NOT found."}.to_json
    end

    def handle_request(request)
      raise NotImplementedError.new("#{self.class.name}##{__method__} is an abstract method.")
    end

    def error_status(result) = :unprocessable_entity # 422

    def error_body(result) = result[:error].to_json

    def on_error(result, response)
      response.status = error_status(result)
      response.body = error_body(result)
    end

    def success_status(result) = :ok # 200

    def success_body(result) = result[:certificate].to_h.to_json

    def on_success(result, response)
      response.status = success_status(result)
      response.body = success_body(result)
    end
  end
end
