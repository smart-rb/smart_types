# frozen_string_literal: true

# @api private
# @since 0.2.0
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
  # @return [SmartCore::Types::Primitive::InvariantControl::Result]
  #
  # @api private
  # @since 0.2.0
  def check(value)
    Result.new(self, value).tap do |result|
      invariant_chains.each do |chain|
        result.add_chain_result(chain.check(value))
      end

      invariants.each do |invariant|
        result.add_single_result(invariant.check(value))
      end
    end
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
