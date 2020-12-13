# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Types::Primitive::MultFactory::DefinitionContext
  # @return [Proc, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :type_caster

  # @return [Proc, NilClass]
  #
  # @api private
  # @since 0.3.0
  attr_reader :type_runtime_attributes_checker

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @type_caster = nil
    @type_runtime_attributes_checker = nil
  end

  # @param caster [Block]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  # @version 0.3.0
  def define_caster(&caster)
    raise(SmartCore::Types::TypeDefinitionError, 'No caster definition block') unless block_given?
    @type_caster = caster
  end

  # @param definition [Block]
  # @return [void]
  #
  # @api public
  # @since 0.3.0
  def runtime_attributes_checker(&definition)
    unless block_given?
      raise(SmartCore::Types::TypeDefinitionError, 'No runtime checker definition block')
    end
    @type_runtime_attributes_checker = definition
  end

  # TODO (0.x.0): invariant API
end
