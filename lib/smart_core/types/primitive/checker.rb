# frozen_string_literal: true

# @api private
# @since 0.1.0
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
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def call(value)
    !!expression.call(value)
  end

  private

  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  attr_reader :expression
end
