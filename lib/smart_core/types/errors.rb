# frozen_string_literal: true

module SmartCore::Types
  # @api public
  # @since 0.1.0
  Error = Class.new(SmartCore::Error)

  # @api public
  # @since 0.1.0
  ArgumentError = Class.new(SmartCore::ArgumentError)

  # @api public
  # @since 0.1.0
  NameError = Class.new(SmartCore::NameError)

  # @api public
  # @since 0.1.0
  TypeCastingError = Class.new(Error)

  # @api public
  # @since 0.1.0
  NoCheckerDefinitionError = Class.new(Error)

  # @api public
  # @since 0.1.0
  IncorrectTypeNameError = Class.new(NameError)
end
