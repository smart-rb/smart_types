# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Types::Primitive::InvariantControl::Factory::ChainDefinitionContext
  # @return [SmartCore::Types::Primitive::InvariantControl::Chain]
  #
  # @api private
  # @since 0.2.0
  attr_reader :___chain___

  # @param chain_name [String]
  # @return [void]
  #
  # @api privae
  # @since 0.2.0
  def initialize(chain_name)
    @___chain___ = SmartCore::Types::Primitive::InvariantControl::Chain.new(chain_name)
  end

  # @param invariant_name [String, Symbol]
  # @param invariant_definition [Block]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  # @version 0.3.0
  def invariant(invariant_name, &invariant_definition)
    SmartCore::Types::Primitive::Factory::DefinitionContext.validate_invariant_attributes!(
      invariant_name,
      &invariant_definition
    )

    ___chain___.add_invariant(
      SmartCore::Types::Primitive::InvariantControl::Single.create(
        invariant_name, invariant_definition
      )
    )
  end
end
