# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Types::Primitive::SumFactory::DefinitionContext
  # @return [Proc, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :type_caster

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @type_caster = nil
  end

  # @param caster [Block]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def define_caster(&caster)
    raise(SmartCore::Types::ArgumentError, 'No caster definition block') unless block_given?
    @type_caster = caster
  end

  # TODO: support for invariants
end
