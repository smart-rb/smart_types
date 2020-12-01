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
  # @version 0.3.0
  def initialize(expression)
    @expression = expression
    @params = []
  end

  # @param value [Any]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  # @version 0.3.0
  def call(value)
    !!expression.call(value, *params)
  end

  # @param params [Array<Any>]
  # @return [void]
  #
  # @api private
  # @since 0.3.0
  def ___assign_params___(params)
    @params = params
  end

  private

  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  attr_reader :expression

  # @return [Proc]
  #
  # @api private
  # @since 0.3.0
  attr_reader :params
end
