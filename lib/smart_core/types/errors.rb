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
  # @since 0.3.0
  TypeDefinitionError = Class.new(ArgumentError)

  # @api public
  # @since 0.3.0
  IncorrectRuntimeAttributesError = Class.new(TypeDefinitionError)

  # @api public
  # @since 0.3.0
  RuntimeAttriburtesUnsupportedError = Class.new(TypeDefinitionError)

  # @api public
  # @since 0.1.0
  TypeError = Class.new(SmartCore::TypeError)

  # @api public
  # @since 0.1.0
  TypeCastingError = Class.new(Error)

  # @api public
  # @since 0.1.0
  TypeCastingUnsupportedError = Class.new(TypeCastingError)

  # @api public
  # @since 0.1.0
  NoCheckerDefinitionError = Class.new(Error)

  # @api public
  # @since 0.1.0
  IncorrectTypeNameError = Class.new(NameError)
end
