# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.3.0
class SmartCore::Types::Primitive::UndefinedCaster < SmartCore::Types::Primitive::Caster
  # @param expression [NilClass, Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(expression = nil)
    super
  end

  # @param value [Any]
  # @param runtime_attributes [Array<Any>]
  # @return [void]
  #
  # @raise [SmartCore::Types::TypeCastingUnsupportedError]
  #
  # @pai private
  # @since 0.1.0
  # @version 0.3.0
  def call(value, runtime_attributes)
    raise(SmartCore::Types::TypeCastingUnsupportedError, <<~ERROR_MESSAGE)
      'This type has no support for type casting'
    ERROR_MESSAGE
  end
end
