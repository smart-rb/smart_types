# frozen_string_literal: true

# @api public
# @since 0.1.0
module SmartCore::Types::System
  class << self
    # @param types [Array<SmartCore::Types::Primitive>]
    # @param type_definition [Block]
    # @return [SmartCore::Types::Primitive]
    #
    # @api public
    # @since 0.1.0
    def type_sum(*types, &type_definition)
      SmartCore::Types::Primitive::SumFactory.create_type(types, type_definition)
    end

    # @param types [Array<SmartCore::Types::Primitive>]
    # @param type_definition [Block]
    # @return [SmartCore::Types::Primitive]
    #
    # @api public
    # @since 0.1.0
    def type_mult(*types, &type_definition)
      SmartCore::Types::Primitive::MultFactory.create_type(types, type_definition)
    end
  end
end
