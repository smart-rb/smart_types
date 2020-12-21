# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.3.0
class SmartCore::Types::Primitive::Checker
  # @param expression [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(expression)
    @expression = expression
  end

  # @param value [Any]
  # @param runtime_attributes [Array<Any>]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  # @version 0.3.0
  def call(value, runtime_attributes)
    !!expression.call(value, runtime_attributes)
  end

  private

  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  attr_reader :expression
end
