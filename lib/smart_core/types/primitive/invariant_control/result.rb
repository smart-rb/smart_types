# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Types::Primitive::InvariantControl::Result
  # @return [Array<SmartCore::Types::Primitive::InvariantControl::Chain::Result>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :chain_results

  # @return [Array<SmartCore::Types::Primitive::InvariantControl::Single::Result>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :single_results

  # @param invariant_control [SmartCore::Types::Primitive::InvariantControl]
  # @param checked_value [Any]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize(invariant_control, checked_value)
    @invariant_control = invariant_control
    @checked_value = checked_value
    @chain_results = []
    @single_results = []
  end

  # @return [Array<String>]
  #
  # @api private
  # @since 0.2.0
  def invariant_errors
    collect_invariant_errors
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.2.0
  def success?
    chain_results.all(&:success?) && single_results.all?(&:success?)
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.2.0
  def failure?
    !success?
  end

  # @param result [SmartCore::Types::Primitive::InvariantControl::Chain::Result]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def add_chain_result(result)
    chain_results << result
  end

  # @param result [SmartCore::Types::Primitive::InvariantControl::Single::Result]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def add_single_result(result)
    single_results << result
  end

  private

  # @return [SmartCore::Types::Primitive::InvariantControl]
  #
  # @api private
  # @since 0.2.0
  attr_reader :invariant_control

  # @return [Any]
  #
  # @api private
  # @since 0.2.0
  attr_reader :checked_value

  # @return [Array<String>]
  #
  # @api private
  # @since 0.2.0
  def collect_invariant_errors
    [].tap do |invariant_errors|
      # collect invariant errors from invariant chains
      chain_results.select(&:failure?).each do |chain_result|
        invariant_errors.concat(chain_result.error_codes)
      end

      single_results.select(&:failure?).each do |single_result|
        invariant_errors.concat(single_result.error_codes)
      end
    end.tap(&:freeze)
  end
end
