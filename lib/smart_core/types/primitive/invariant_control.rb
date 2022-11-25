# frozen_string_literal: true

# @api private
# @since 0.2.0
# @version 0.8.0
class SmartCore::Types::Primitive::InvariantControl
  require_relative 'invariant_control/result'
  require_relative 'invariant_control/single'
  require_relative 'invariant_control/chain'
  require_relative 'invariant_control/factory'

  class << self
    # @param invariant_chains [Hash<String,Array<Proc>>]
    # @param invariants [Hash<String,Proc>]
    # @return [SmartCore::Types::Primitive::InvariantControl]
    #
    # @api private
    # @since 0.2.0
    def create(invariant_chains, invariants)
      Factory.create(invariant_chains, invariants)
    end
  end

  # @param invariant_chains [Array<SmartCore::Types::Primitive::InvariantControl::Chain>]
  # @param invariants [Array<SmartCore::Types::Primitive::InvariantControl::Single>]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize(invariant_chains, invariants)
    @invariant_chains = invariant_chains
    @invariants = invariants
  end

  # @param value [Any]
  # @param runtime_attributes [Array<Any>]
  # @return [SmartCore::Types::Primitive::InvariantControl::Result]
  #
  # @api private
  # @since 0.2.0
  # @version 0.3.0
  def check(value, runtime_attributes)
    Result.new(self, value).tap do |result|
      invariant_chains.each do |chain|
        result.add_chain_result(chain.check(value, runtime_attributes))
      end

      invariants.each do |invariant|
        result.add_single_result(invariant.check(value, runtime_attributes))
      end
    end
  end

  # @param value [Any]
  # @param runtime_attributes [Array<Any>]
  # @return [Boolean]
  #
  # @api private
  # @since 0.8.0
  def simply_check(value, runtime_attributes)
    return false if invariant_chains.any? do |chain|
      chain.simply_check(value, runtime_attributes) == false
    end

    return false if invariants.any? do |invariant|
      invariant.simply_check(value, runtime_attributes) == false
    end

    true
  end

  private

  # @return [Array<SmartCore::Types::Primitive::InvariantControl::Chain>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :invariant_chains

  # @return [Array<SmartCore::Types::Primitive::InvariantControl::Single>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :invariants
end
