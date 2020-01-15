# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Types::Primitive::Factory::TypeDefinitions
  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  attr_reader :type_checker

  # @return [Proc]
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
    @type_checker = checker
  end

  # @param caster [Block]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def define_caster(&caster)
    @type_caster = caster
  end
end
