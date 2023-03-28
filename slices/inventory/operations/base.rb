# frozen_string_literal: true

module Inventory
  module Operations
    class Base
      include Deps[
        "settings",
        "repositories.certificates"
      ]
    end
  end
end