# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Types::Primitive::SumChecker
  # @param [Array<SmartCore::Types::Primitive::Checker>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(*checkers)
    @checkers = checkers
  end

  # @param value [Any]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def call(value)
    checkers.any? { |checker| checker.call(value) }
  end

  private

  # @return [Array<SmartCore::Types::Primitive::Checker>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :checkers
end
