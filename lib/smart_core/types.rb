# frozen_string_literal: true

require 'smart_core'

# @api public
# @since 0.1.0
module SmartCore::Types
  require_relative 'types/version'
  require_relative 'types/errors'
  require_relative 'types/system'
  require_relative 'types/primitive'
  require_relative 'types/value'
  require_relative 'types/varied'
  require_relative 'types/protocol'
end
