# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Types::Primitive::SumFactory
  require_relative 'sum_factory/definition_context'

  class << self
    # @param types [Array<SmartCore::Types::Primtive>]
    # @param type_definition [NilClass, Proc]
    # @return [SmartCore::Types::Primitive]
    #
    # @api private
    # @since 0.1.0
    def create_type(types, type_definition)
      type_definitions = build_type_definitions(type_definition)
      type_checker = build_type_checker(types, type_definitions)
      type_caster = build_type_caster(types, type_definitions)
      build_type(type_checker, type_caster)
    end

    private

    # @param type_definition [NilClass, Proc]
    # @return [SmartCore::Types::Primitive::SumFactory::DefinitionContext]
    #
    # @pai private
    # @since 0.1.0
    def build_type_definitions(type_definition)
      SmatCore::Types::Primitive::SumFactory::DefinitionContext.new.tap do |context|
        context.instance_eval(&type_definition) if type_definition
      end
    end

    # @param types [Array<SmartCore::Types::Primtive>]
    # @param type_definitions [SmartCore::Types::Primitive::SumFactory::DefinitionContext]
    # @return [SmartCore::Types::Primitive::SumChecker]
    #
    # @api private
    # @since 0.1.0
    def build_type_checker(types, type_definitions)
      SmartCore::Types::Primitive::SumChecker.new(*types.map(&:checker))
    end

    # @param types [Array<SmartCore::Types::Primtive>]
    # @param type_definition [SmartCore::Types::Primitive::SumFactory::DefinitionContext]
    # @return [SmartCore::Types::Primitive::Caster]
    #
    # @api private
    # @since 0.1.0
    def build_type_caster(types, type_definitions)
      if type_definitions.type_caster.nil?
        SmartCore::Types::Primitive::UndefinedCaster.new
      else
        SmartCore::Types::Primitive::Caster.new(type_definitions.type_caster)
      end
    end

    # @param type_checker [SmartCore::Types::Primitive::SumChecker]
    # @param type_caster [SmartCore::Types::Primitive::Caster]
    # @return [SmartCore::Types::Primitive]
    #
    # @api private
    # @since 0.1.0
    def build_type(type_checker, type_caster)
      SmartCore::Types::Primitive.new(type_checker, type_caster)
    end
  end
end
