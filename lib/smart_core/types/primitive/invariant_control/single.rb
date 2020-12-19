# frozen_string_literal: true

# @api private
# @since 0.2.0
# @version 0.3.0
class SmartCore::Types::Primitive::InvariantControl::Single
  require_relative 'single/result'

  class << self
    # @param name [String, Symbol]
    # @param invariant_checker [Proc]
    # @return [SmartCore::Types::Primitive::InvariantControl::Single]
    #
    # @api private
    # @since 0.2.0
    def create(name, invariant_checker)
      new(name.to_s, invariant_checker)
    end
  end

  # @return [String]
  #
  # @api private
  # @since 0.2.0
  attr_reader :name

  # @param name [String]
  # @param invariant_checker [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize(name, invariant_checker)
    @name = name.dup.tap(&:freeze)
    @invariant_checker = invariant_checker
  end

  # @param value [Any]
  # @param runtime_attributes [Array<Any>]
  # @return [SmartCore::Types::Primitive::InvariantControl::Single::Result]
  #
  # @api private
  # @since 0.2.0
  # @version 0.3.0
  def check(value, runtime_attributes)
    validation_result = !!invariant_checker.call(value, runtime_attributes)
    Result.new(self, value, validation_result)
  end

  private

  # @return [Proc]
  #
  # @api private
  # @since 0.2.0
  attr_reader :invariant_checker
end
