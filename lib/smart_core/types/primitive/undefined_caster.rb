# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Types::Primitive::UndefinedCaster
  # @param value [Any]
  # @return [void]
  #
  # @raise
  #
  # @pai private
  # @since 0.1.0
  def call(value)
    raise 'no_type_casting_support'
  end
end
