# frozen_string_literal: true

module Inventory
  module Operations
    class FindCertificates < Base
      def by_id(id) =
        { certificate: certificates.find(id) }

      def by_common_name(common_name) = {
        certificates: certificates.find_by_common_name(common_name)
      }

      def by_status(status) =
        { certificates: certificates.find_by_status(status) }

      def by_host(host) =
        { certificates: certificates.find_by_host(host) }

      def by_ip_address(ip_address) = {
        certificates: certificates.find_by_ip_address(ip_address)
      }

      def by_dns_record(dns_record) = {
        certificates: certificates.find_by_dns_record(dns_record)
      }

      def requested =
        { certificates: certificates.find_requested }

      def issued =
        { certificates: certificates.find_issued }

      def deployed =
        { certificates: certificates.find_deployed }

      def renewable = {
        certificates: certificates.find_renewable(settings.days_before_renewal)
      }

      def renewing =
        { certificates: certificates.find_renewing }

      def revoking =
        { certificates: certificates.find_revoking }

      def revoked =
        { certificates: certificates.find_revoked }

      def expires_in(days) =
        { certificates: certificates.find_expires_in(days) }

      def expirable =
        { certificates: certificates.find_expirable }

      def retirable = {
        certificates: certificates.find_retirable(settings.days_before_retirement)
      }
    end
  end
end
