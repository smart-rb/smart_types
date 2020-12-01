# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.2.0
class SmartCore::Types::Primitive::Factory
  require_relative 'factory/definition_context'

  class << self
    # @param type_category [Class<SmartCore::Types::Primitive>]
    # @param type_name [String, Symbol]
    # @param type_definition [Proc]
    # @return [SmartCore::Types::Primitive]
    #
    # @api private
    # @since 0.1.0
    # @version 0.2.0
    def create_type(type_category, type_name, type_definition)
      type_definitions = build_type_definitions(type_definition)
      type_checker = build_type_checker(type_definitions)
      type_caster = build_type_caster(type_definitions)
      type_invariant_control = build_type_invariant_control(type_definitions)
      type_validator = build_type_validator(type_checker, type_invariant_control)
      build_type(type_category, type_name, type_validator, type_caster).tap do |type|
        assign_type_validator(type, type_validator)
        register_new_type(type_category, type_name, type)
      end
    end

    private

    # @param type_definition [Proc]
    # @return [SmartCore::Types::Primitive::Factory::DefinitionContext]
    #
    # @raise [SmartCore::Types::NoCheckerDefinitionError]
    #
    # @api private
    # @since 0.1.0
    def build_type_definitions(type_definition)
      raise 'Type definition is not provided' unless type_definition.is_a?(Proc)
      SmartCore::Types::Primitive::Factory::DefinitionContext.new.tap do |context|
        context.instance_eval(&type_definition)
      end.tap do |context|
        raise(
          SmartCore::Types::NoCheckerDefinitionError,
          'Type checker is not provided. You should define it via .define_checker(&block)'
        ) if context.type_checker == nil
      end
    end

    # @param type_definitions [SmartCore::Types::Primitive::Factory::DefinitionContext]
    # @return [SmartCore::Types::Primitive::InvariantControl]
    #
    # @api private
    # @since 0.2.0
    def build_type_invariant_control(type_definitions)
      SmartCore::Types::Primitive::InvariantControl.create(
        type_definitions.type_invariant_chains,
        type_definitions.type_invariants
      )
    end

    # @param type_definitions [SmartCore::Types::Primitive::Factory::DefinitionContext]
    # @return [SmartCore::Types::Primitive::Checker]
    #
    # @api private
    # @since 0.1.0
    def build_type_checker(type_definitions)
      SmartCore::Types::Primitive::Checker.new(type_definitions.type_checker)
    end

    # @param type_definitions [SmartCore::Types::Primitive::Factory::DefinitionContext]
    # @return [SmartCore::Types::Primitive::Caster]
    #
    # @api private
    # @since 0.1.0
    def build_type_caster(type_definitions)
      if type_definitions.type_caster == nil
        SmartCore::Types::Primitive::UndefinedCaster.new
      else
        SmartCore::Types::Primitive::Caster.new(type_definitions.type_caster)
      end
    end

    # @param type_checker [SmartCore::Types::Primitive::Checker]
    # @param type_invariant_control [SmartCore::Types::Primitive::InvariantControl]
    # @return [void]
    #
    # @api private
    # @since 0.2.0
    def build_type_validator(type_checker, type_invariant_control)
      SmartCore::Types::Primitive::Validator.new(type_checker, type_invariant_control)
    end

    # @param type_category [Class<SmartCore::Types::Primitive>]
    # @param type_name [String, Symbol]
    # @param type_validator [SmartCore::Types::Primitive::Validator]
    # @param type_caster [SmartCore::Types::Primitive::Caster]
    # @return [SmartCore::Types::Primitive]
    #
    # @api private
    # @since 0.1.0
    # @version 0.2.0
    def build_type(type_category, type_name, type_validator, type_caster)
      Class.new(type_category).new(type_name, type_validator, type_caster)
    end

    # @param type [SmartCore::Types::Primitive]
    # @param type_validator [SmartCore::Types::Primitive::Validator]
    # @return [void]
    #
    # @api private
    # @since 0.2.0
    def assign_type_validator(type, type_validator)
      type_validator.___assign_type___(type)
    end

    # @param type_category [Class<SmartCore::Types::Primitive>]
    # @param type_name [String, Symbol]
    # @param type [SmartCore::Types::Primitive]
    # @return [void]
    #
    # @raise [SmartCore::Types::IncorrectTypeNameError]
    #
    # @api private
    # @since 0.1.0
    def register_new_type(type_category, type_name, type)
      type_category.const_set(type_name, type)
    rescue ::NameError
      raise(
        SmartCore::Types::IncorrectTypeNameError,
        "Incorrect constant name for new type (#{type_name})"
      )
    end
  end
end
