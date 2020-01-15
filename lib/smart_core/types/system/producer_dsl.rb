# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Types::System::ProducerDSL
  class << self
    # @param base_klass [Class<SmartCore::Types::Primitive>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def inlcuded(base_klass)
      base_klass.extend(ClassMethods)
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @param type_name [String, Symbol]
    # @param type_definition [Block]
    # @return [SmartCore::Types::Primitive]
    #
    # @api public
    # @since 0.1.0
    def define_type(type_name, &type_definition)
      self::Factory.create_type(self, type_name, type_definition)
    end
  end
end
