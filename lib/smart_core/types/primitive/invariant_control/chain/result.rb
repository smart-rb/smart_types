# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Types::Primitive::InvariantControl::Chain::Result
  # @return [SmartCore::Types::Primitive::invariantControl::Chain]
  #
  # @api private
  # @since 0.2.0
  attr_reader :invariant_chain

  # @return [Any]
  #
  # @api private
  # @since 0.2.0
  attr_reader :checked_value

  # @param invariant_chain [SmartCore::Types::Primitive::invariantControl::Chain]
  # @param checked_value [Any]
  # @param invariant_results [Array<SmartCore::Types::Primitive::InvariantControl::Single::Result>]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize(invariant_chain, checked_value, invariant_results)
    @invariant_chain = invariant_chain
    @checked_value = checked_value
    @invariant_results = invariant_results
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.2.0
  def success?
    invariant_results.all?(&:success?)
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.2.0
  def failure?
    invariant_results.any?(&:failure?)
  end

  # @return [Array<String>]
  #
  # @api private
  # @since 0.1.0
  def error_codes
    invariant_results.select(&:failure?).map do |invariant_result|
      "#{invariant_chain.name}.#{invariant_result.invariant.name}".tap(&:freeze)
    end
  end

  private

  # @return [Array<SmartCore::Types::Primitive::InvariantControl::Single::Result>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :invariant_results
end
