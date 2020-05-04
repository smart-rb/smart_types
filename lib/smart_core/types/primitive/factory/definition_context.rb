# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Types::Primitive::Factory::DefinitionContext
  # @return [Proc, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :type_checker

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
    @type_checker = nil
    @type_caster = nil
  end

  # @param checker [Block]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def define_checker(&checker)
    raise(SmartCore::ArgumentError, 'No checker definition block') unless block_given?
    @type_checker = checker
  end

  # @param caster [Block]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def define_caster(&caster)
    raise(SmartCore::ArgumentError, 'No caster definition block') unless block_given?
    @type_caster = caster
  end
end
