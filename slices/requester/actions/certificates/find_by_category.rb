# frozen_string_literal: true

module Requester
  module Actions
    module Certificates
      class FindByCategory < Finder
        protected

        def find(_params)
          find_certificates.send(attribute)
        end

        def attribute = inflector.singularize(
          inflector.tableize(self.class.name.split('Find').last)
        )
      end
    end
  end
end
