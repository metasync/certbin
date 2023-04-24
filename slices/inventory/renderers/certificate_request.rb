# frozen_string_literal: true

require 'erb'

module Inventory
  module Renderers
    class CertificateRequest
      def render_webserver_certificate_request(certificate)
        template_file = File.join(File.expand_path('templates', __dir__),
                                  "#{certificate[:template]}_certificate_request.erb")
        ERB.new(File.read(template_file), trim_mode: '<>').result(binding)
      end
    end
  end
end
