# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Types::System
  require_relative 'system/producer_dsl'
  require_relative 'system/definition_dsl'

  # @since 0.1.0
  include SmartCore::Types::System::DefinitionDSL
end
