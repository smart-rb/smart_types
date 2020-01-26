# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Types::System::DefinitionDSL
  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(base_klass)
      base_klass.extend(ClassMethods)
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @param type_name [String, Symbol]
    # @param types [Array<SmartCore::Types::Pirmitive>]
    # @param type_definition [Block]
    # @return [SmartCore::Types::Primitive]
    #
    # @api public
    # @since 0.1.0
    def type_sum(type_name, *types, &type_definition)
      SmartCore::Types::Primitive::SumFactory.create_type(type_name, types, type_definition)
    end

    # @param type_name [String, Symbol]
    # @param types [Array<SmartCore::Types::Pirmitive>]
    # @param type_definition [Block]
    # @return [SmartCore::Types::Primitive]
    #
    # @api public
    # @since 0.1.0
    def type_mult(type_name, *types, &type_definition)
      SmartCore::Types::Primitive::MultFactory.create_type(type_name, types, type_definition)
    end
  end
end
