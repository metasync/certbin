# frozen_string_literal: true

module Inventory
  module Operations
    class UpdateCertificate < Base
      def call(id, **opts)
        certificate = find_certificate(id)
        if updatable?(certificate)
          update_certificate(certificate, **opts)
        else
          render_error(certificate)
        end
      end

      protected

      def find_certificate(id) = certificates.find(id)

      def updatable?(certificate)
        raise NotImplementedError.new("#{self.class.name}##{__method__} is an abstract method.")
      end

      def update_certificate(certificate, **opts) = {
        certificate: certificates.update(
          certificate.id, 
          updated_at: Time.now ,
          **certificate_updates(certificate, **opts)
        )
      }

      def certificate_updates(certificate, **opts)
        raise NotImplementedError.new("#{self.class.name}##{__method__} is an abstract method.")
      end

      def render_error(certificate) = {
        error: error(certificate)
      }

      def error(certificate)
        raise NotImplementedError.new("#{self.class.name}##{__method__} is an abstract method.")
      end
    end
  end
end