# frozen_string_literal: true

# @api private
# @since 0.3.0
class SmartCore::Types::Primitive::InvariantControl::Factory::ChainDefinitionContext
  # @return []
  #
  # @api private
  # @since 0.3.0
  attr_reader :___chain___

  # @return [void]
  #
  # @api privae
  # @since 0.3.0
  def initialize(chain_name)
    @___chain___ = SmartCore::Types::Primitive::InvariantControl::Chain.new(chain_name)
  end

  # @param invariant_name [String, Symbol]
  # @param invariant_definition [Block]
  # @return [void]
  #
  # @api private
  # @since 0.3.0
  def invariant(invariant_name, &invariant_definition)
    unless invariant_name.is_a?(::String) || invariant_name.is_a?(::Symbol)
      raise(SmartCore::Types::ArgumentError, <<~ERROR_MESSAGE)
        Invariant name should be a type of string or a symbol.
      ERROR_MESSAGE
    end

    unless block_given?
      raise(SmartCore::Types::ArgumentError, <<~ERROR_MESSAGE)
        Invariant logic is not porvided (you should provide this logic as a block).
      ERROR_MESSAGE
    end

    ___chain___.add_invariant(
      SmartCore::Types::Primitive::InvariantControl::Single.create(
        invariant_name, invariant_definition
      )
    )
  end
end
