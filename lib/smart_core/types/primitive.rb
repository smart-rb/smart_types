# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.2.0
class SmartCore::Types::Primitive
  require_relative 'primitive/checker'
  require_relative 'primitive/caster'
  require_relative 'primitive/runtime_attributes_checker'
  require_relative 'primitive/undefined_caster'
  require_relative 'primitive/invariant_control'
  require_relative 'primitive/validator'
  require_relative 'primitive/factory'
  require_relative 'primitive/sum_validator'
  require_relative 'primitive/sum_factory'
  require_relative 'primitive/mult_validator'
  require_relative 'primitive/mult_factory'
  require_relative 'primitive/nilable_validator'
  require_relative 'primitive/nilable_factory'

  class << self
    # @param type_name [String, Symbol]
    # @param type_definition [Block]
    # @yield [type]
    # @yieldparam type [SmartCore::Types::Primitive::DefinitionContext]
    # @yieldreturn [void]
    # @return [SmartCore::Types::Primitive]
    #
    # @api public
    # @since 0.1.0
    def define_type(type_name, &type_definition)
      self::Factory.create_type(self, type_name, type_definition)
    end
  end

  # @note NilClass is suitable for sum-types, mult-types and nilable types.
  # @return [String, NilClass]
  #
  # @api public
  # @since 0.2.0
  attr_reader :name

  # @return [Class<SmartCore::Types::Primitive>]
  #
  # @api private
  # @since 0.3.0
  attr_reader :category

  # @return [Array<Any>]
  #
  # @api private
  # @since 0.3.0
  attr_reader :runtime_attributes

  # @return [SmartCore::Types::Primitive::RuntimeAttributesChecker]
  #
  # @api private
  # @since 0.3.0
  attr_reader :runtime_attributes_checker

  # @return [SmartCore::Types::Primitive::Caster]
  #
  # @api private
  # @since 0.1.0
  attr_reader :caster

  # @return [SmartCore::Types::Primitive::Validator]
  # @return [SmartCore::Types::Primitive::SumValidator]
  # @return [SmartCore::Types::Primitive::MultValidator]
  # @return [SmartCore::Types::primitive::NilableValidator]
  #
  # @api private
  # @since 0.2.0
  attr_reader :validator

  # @param name [String, NilClass] NilClass is suitable for sum-types, mult-types and nilable types.
  # @param category [Class<SmartCore::Types::Primitive>, NilClass]
  # @param validator [
  #   SmartCore::Types::Primitive::Validator,
  #   SmartCore::Types::Primitive::SumValidator,
  #   SmartCore::Types::Primitive::MultValidator,
  #   SmartCore::Types::Primitive::NilableValidator
  # ]
  # @param caster [SmartCore::Types::Primitive::Caster]
  # @param runtime_attributes_checker [SmartCore::Types::Primitive::RuntimeAttributesChecker]
  # @param runtime_attributes [Array<Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.3.0
  # rubocop:disable Metrics/ParameterLists
  def initialize(name, category, validator, caster, runtime_attributes_checker, *runtime_attributes)
    @name = name
    @category = category
    @validator = validator
    @caster = caster
    @nilable = nil
    @runtime_attributes_checker = runtime_attributes_checker
    @runtime_attributes = runtime_attributes
    @lock = SmartCore::Engine::Lock.new
  end
  # rubocop:enable Metrics/ParameterLists

  # @param cloneable_instance [SmartCore::Types::Primitive]
  # @return [SmartCore::Types::Primitive]
  #
  # @api private
  # @since 0.3.0
  def initialize_copy(cloneable_instance)
    lock.synchronize do
      self.class::Factory::RuntimeTypeBuilder.initialize_clone(self, cloneable_instance)
    end
  end

  # @param value [Any]
  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  # @since 0.2.0
  def valid?(value)
    validator.valid?(value)
  end

  # @param value [Any]
  # @return [void]
  #
  # @raise [SmartCore::Types::TypeError]
  # @see SmartCore::Primitive::Validator
  # @see SmartCore::Primitive::MultValidator
  # @see SmartCore::Primitive::SumValidator
  # @see SmartCore::Primitive::NilableValidator
  #
  # @api public
  # @since 0.1.0
  # @version 0.2.0
  def validate!(value)
    validator.validate!(value)
  end

  # @return [SmartCore::Types::Primitive::Validator::Result]
  #
  # @see SmartCore::Primitive::Validator
  # @see SmartCore::Primitive::MultValidator
  # @see SmartCore::Primitive::SumValidator
  # @see SmartCore::Primitive::NilableValidator
  #
  # @api public
  # @since 0.2.0
  def validate(value)
    validator.validate(value)
  end

  # @param value [Any]
  # @return [Any]
  #
  # @api public
  # @since 0.1.0
  def cast(value)
    # TODO (0.x.0):
    #   refactor with ValueTransformer with internal reference to the type object
    #   in Validator manner (in order to avoid explicit #runtime_attributes passing)
    caster.call(value, runtime_attributes)
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
