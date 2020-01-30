# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Types::Primitive
  require_relative 'primitive/caster'
  require_relative 'primitive/undefined_caster'
  require_relative 'primitive/checker'
  require_relative 'primitive/nilable_checker'
  require_relative 'primitive/sum_checker'
  require_relative 'primitive/mult_checker'
  require_relative 'primitive/factory'
  require_relative 'primitive/sum_factory'
  require_relative 'primitive/mult_factory'
  require_relative 'primitive/nilable_factory'

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
  # @param name [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(checker, caster)
    @lock = SmartCore::Engine::Lock.new
    @checker = checker
    @caster = caster
    @nilable = nil
  end

  # @return [String]
  #
  # @api public
  # @since 0.1.0
  def name
    self.class.name
  end

  # @param value [Any]
  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def valid?(value)
    checker.call(value)
  end

  # @return [void]
  #
  # @raise [SmartCore::TypeError]
  #
  # @api public
  # @since 0.1.0
  def validate!(value)
    return if valid?(value)

    # rubocop:disable Layout/RescueEnsureAlignment
    value_type = begin
      value.class.name
    rescue NoMethodError
      (class << value; superclass; end).name
    end
    # rubocop:enable Layout/RescueEnsureAlignment

    raise(SmartCore::Types::TypeError, <<~ERROR_MESSAGE)
      Invalid type (given #{value_type}, expects #{self.class.name}/SmartCore)
    ERROR_MESSAGE
  end

  # @param value [Any]
  # @return [Any]
  #
  # @api public
  # @since 0.1.0
  def cast(value)
    caster.call(value)
  end

  # @return [SmartCore::Types::Primitive]
  #
  # @api public
  # @since 0.1.0
  def nilable
    lock.synchronize { @nilable ||= self.class::NilableFactory.create_type(self) }
  end

  # @param another_primitive [SmartCore::Types::Primitive]
  # @return [SmartCore::Types::Primitive]
  #
  # @api public
  # @since 0.1.0
  def |(another_primitive)
    self.class::SumFactory.create_type([self, another_primitive])
  end

  # @param another_primitive [SmartCore::Types::Primitive]
  # @return [SmartCore::Types::Primitive]
  #
  # @api public
  # @since 0.1.0
  def &(another_primitive)
    self.class::MultFactory.create_type([self, another_primitive])
  end

  private

  # @return [SmartCore::Engine::Lock]
  #
  # @api private
  # @since 0.1.0
  attr_reader :lock
end
