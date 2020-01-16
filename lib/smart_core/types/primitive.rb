# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Types::Primitive
  require_relative 'primitive/caster'
  require_relative 'primitive/undefined_caster'
  require_relative 'primitive/checker'
  require_relative 'primitive/sum_checker'
  require_relative 'primitive/mult_checker'
  require_relative 'primitive/factory'
  require_relative 'primitive/sum_factory'
  require_relative 'primitive/mult_factory'

  # @since 0.1.0
  include SmartCore::Types::System::ProducerDSL

  # @return [SmartCore::Types::Primitive::Checker]
  #
  # @api private
  # @since 0.1.0
  attr_reader :checker

  # @return [SmartCore::Types::Primitive::Caster]
  #
  # @api private
  # @since 0.1.0
  attr_reader :caster

  # @param checker [SmartCore::Types::Primitive::Checker]
  # @param caster [SmartCore::Types::Primitive::Caster]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(checker, caster)
    @checker = checker
    @caster = caster
  end

  # @param value [Any]
  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def valid?(value)
    checker.call(value)
  end

  # @param value [Any]
  # @return [Any]
  #
  # @api public
  # @since 0.1.0
  def cast(value)
    caster.call(value)
  end

  # @param another_primitive [SmartCore::Types::Primitive]
  # @return [SmartCore::Types::Primitive]
  #
  # @api public
  # @since 0.1.0
  def |(another_primitive)
    self.class::SumFactory.create_type(self, another_primitive)
  end

  # @param another_primitive [SmartCore::Types::Primitive]
  # @return [SmartCore::Types::Primitive]
  #
  # @api public
  # @since 0.1.0
  def &(another_primitive)
    self.class::MultFactory.create_type(self, another_primitive)
  end
end
