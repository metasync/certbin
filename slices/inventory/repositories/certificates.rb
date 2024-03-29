# frozen_string_literal: true

module Inventory
  module Repositories
    class Certificates < Certbin::Repository[:certificates]
      include Deps[
        'repositories.certificate_ip_addresses',
        'repositories.certificate_dns_records',
        'repositories.certificate_hosts'
      ]

      commands update: :by_pk, delete: :by_pk

      def create(certificate)
        base_query.command(:create).call(certificate)
      end

      def find(id) = base_query.by_pk(id).one!

      def find_by_common_name(common_name) =
        base_query.where(common_name:).to_a

      def find_by_status(status) =
        base_query.where(status:).to_a

      def find_renewable(days_before_renewal) =
        base_query.where do
          Sequel[{ status: 'expired' }] |
            (
              (Sequel[{ status: 'deployed' }]) &
              (
                (expires_on <= Time.now + (days_before_renewal * 24 * 60 * 60)) &
                (expires_on > Time.now)
              )
            )
        end.to_a

      def find_requested = find_by_status('requested')

      def find_issued = find_by_status('issued')

      def find_deployed = find_by_status('deployed')

      def find_renewing = find_by_status('renewing')

      def find_revoking = find_by_status('revoking')

      def find_revoked = find_by_status('revoked')

      def find_expires_in(days) =
        base_query
          .where(status: %w[issued deployed])
          .where do
            (expires_on <= Time.now + (days * 24 * 60 * 60)) &
              (expires_on > Time.now)
          end
          .order { expires_on.desc }
          .to_a

      def find_expirable =
        base_query
          .where(status: %w[issued deployed])
          .where { expires_on <= Time.now }
          .order { expires_on.desc }
          .to_a

      def find_retirable(days_before_retirement) =
        base_query
          .where(status: 'expired')
          .where { expired_at <= Time.now - (days_before_retirement * 24 * 60 * 60) }
          .order { expires_on.desc }
          .to_a

      def find_withdrawable = find_revoked

      def find_by_ip_address(ip_address)
        certificate_ids =
          certificate_ip_addresses.where(
            value: ip_address
          ).select(:certificate_id).to_a.map(&:certificate_id)
        base_query
          .where do
            { id: certificate_ids }
          end.to_a
      end

      def find_by_dns_record(dns_record)
        certificate_ids =
          certificate_dns_records.where(
            value: dns_record
          ).select(:certificate_id).to_a.map(&:certificate_id)
        base_query
          .where do
            { id: certificate_ids }
          end.to_a
      end

      def find_by_host(host)
        certificate_ids =
          certificate_hosts.where(
            value: host
          ).select(:certificate_id).to_a.map(&:certificate_id)
        base_query
          .where do
            { id: certificate_ids }
          end.to_a
      end

      def delete_all =
        certificates.command(:delete).call

      private

      def base_query =
        certificates
          .combine(:dns_records)
          .combine(:ip_addresses)
          .combine(:hosts)
    end
  end
end
