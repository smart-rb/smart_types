# frozen_string_literal: true

# @api private
# @since 0.2.0
module SmartCore::Types::Primitive::InvariantControl::Factory
  require_relative 'factory/chain_definition_context'

  class << self
    # @param invariant_chains [Hash<String,Array<Proc>]
    # @param invariants [Hash<String,Proc>]
    # @return [SmartCore::Types::Primitive::InvariantControl]
    #
    # @api private
    # @since 0.2.0
    def create(invariant_chains, invariants)
      completed_invariant_chains = build_invariant_chains(invariant_chains)
      completed_invariants = build_invariants(invariants)

      SmartCore::Types::Primitive::InvariantControl.new(
        completed_invariant_chains,
        completed_invariants
      )
    end

    private

    # @param invariant_chains [Hash<String,Array<Proc>]
    # @return [Array<SmartCore::Types::Primitive::InvariantControl::Chain>]
    #
    # @api private
    # @since 0.2.0
    def build_invariant_chains(invariant_chains)
      invariant_chains.map do |chain_name, chain_invariants|
        context = ChainDefinitionContext.new(chain_name)
        chain_invariants.each { |invariant_logic| context.instance_eval(&invariant_logic) }
        context.___chain___
      end
    end

    # @param invariants [Hash<String,Proc>]
    # @return [Array<SmartCore::Types::Primitive::InvariantControl::Single>]
    #
    # @api private
    # @since 0.2.0
    def build_invariants(invariants)
      invariants.map do |invariant_name, invariant_logics|
        SmartCore::Types::Primitive::InvariantControl::Single.create(
          invariant_name,
          invariant_logics
        )
      end
    end
  end
end
