# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Types::Primitive::Factory
  require_relative 'factory/type_definitions'

  # @param type_category [Class<SmartCore::Types::Primitive>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(type_category)
    @type_category = type_category
  end

  # @param type_name [String, Symbol]
  # @param type_definition [Block]
  # @return [SmartCore::Types::Primitive]
  #
  # @api private
  # @since 0.1.0
  def create_type(type_category, type_name, &type_definition)
    type_definitions = build_type_definitions(type_definition)
    type_checker = build_type_checker(type_definitions)
    type_caster = build_type_caster(type_definitions)
    type = build_type(type_definitions)
    type.tap { type_category.const_set(:type_name, type) }
  end

  private

  # @return [Class<SmartCore::Types::Primitive>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :type_category

  # @param type_definition [Proc]
  # @return [SmartCore::Types::Primitive::Factory::TypeDefinitions]
  #
  # @api private
  # @since 0.1.0
  def build_type_definitions(type_definition)
    SmartCore::Types::Primitive::Factory::TypeDefinitions.new.tap do |definitions|
      definitions.instance_eval(&type_definition)
    end
  end

  # @param type_definitions [SmartCore::Types::Primitive::Factory::TypeDefinitions]
  # @return [SmartCore::Types::Primitive::Checker]
  #
  # @api private
  # @since 0.1.0
  def build_type_checker(type_definitions)
    SmartCore::Types::Primitive::Checker.new(type_definitions.type_checker)
  end

  # @param type_definitions [SmartCore::Types::Primitive::Factory::TypeDefinitions]
  # @return [SmartCore::Types::Primitive::Caster]
  #
  # @api private
  # @since 0.1.0
  def build_type_caster(type_definitions)
    SmartCore::Types::Primitive::Caster.new(type_definitions.type_caster)
  end

  # @param type_klass [Class<SmartCore::Types::Primitive>]
  # @param type_definitions [SmartCore::Types::Primitive::Factory::TypeDefinitions]
  # @return [SmartCore::Types::Primitive]
  #
  # @api private
  # @since 0.1.0
  def build_type(type_klass, type_definitions)
    Class.new(type_category).new(type_definitions.checker, type_definitions.caster)
  end
end
