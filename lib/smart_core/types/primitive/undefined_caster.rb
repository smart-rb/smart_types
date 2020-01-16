# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Types::Primitive::UndefinedCaster
  # @param value [Any]
  # @return [void]
  #
  # @raise [SmartCore::Types::NoTypeCastSupportError]
  #
  # @pai private
  # @since 0.1.0
  def call(value)
    raise(
      SmartCore::Types::NoTypeCastSupportError,
      'This type has no support for type casting'
    )
  end
end
