# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Types::Primitive::NilableChecker
  # @param checker [Checker, SumChecker, MultChecker, NilableChecker]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(checker)
    @checker = checker
  end

  # @param value [Any]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def call(value)
    # rubocop:disable Style/NilComparison
    # NOTE: #nil? is not used cuz BasicObject has no #nil? method
    (value == nil) ? true : checker.call(value)
    # rubocop:enable Style/NilComparison
  end

  private

  # @return [SmartCore::Types::Primitive::Checker]
  # @return [SmartCore::Types::Primitive::MultChecker]
  # @return [SmartCore::Types::Primitive::SumChecker]
  # @return [SmartCore::Types::Primitive::NilableChecker]
  #
  # @api private
  # @since 0.1.0
  attr_reader :checker
end
