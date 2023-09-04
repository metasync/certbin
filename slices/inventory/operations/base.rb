# frozen_string_literal: true

module Inventory
  module Operations
    class Base
      include Deps[
        'inflector',
        'settings',
        'repositories.certificates',
        'operations.write_audit_log'
      ]

      def action
        inflector.singularize(
          inflector.tableize(
            inflector.demodulize(self.class.name)
          )
        )
      end
    end
  end
end
