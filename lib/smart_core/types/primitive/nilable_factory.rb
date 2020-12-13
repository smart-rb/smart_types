# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.3.0
module SmartCore::Types::Primitive::NilableFactory
  class << self
    # @param type [SmartCore::Types::Primitive]
    # @return [SmartCore::Type::Primitive]
    #
    # @api private
    # @since 0.1.0
    # @version 0.2.0
    def create_type(type)
      type_validator = build_type_validator(type)
      type_caster = build_type_caster(type)
      build_type(type, type_validator, type_caster).tap do |new_type|
        assign_type_validator(new_type, type_validator)
      end
    end

    private

    # @param type [SmartCore::Types::Primitive]
    # @return [SmartCore::Types::Primitive::NilableValidator]
    #
    # @api private
    # @since 0.2.0
    def build_type_validator(type)
      SmartCore::Types::Primitive::NilableValidator.new(type.validator)
    end

    # @param type [SmartCore::Types::Primitive]
    # @return [SmartCore::Types::Primitive::Caster]
    #
    # @api private
    # @since 0.1.0
    def build_type_caster(type)
      type.caster
    end

    # @param type [SmartCore::Types::Primitive]
    # @param type_validator [SmartCore::Types::Primitive::NilableValidator]
    # @return [void]
    #
    # @api private
    # @since 0.2.0
    def assign_type_validator(type, type_validator)
      type_validator.___assign_type___(type)
    end

    # @param type [SmartCore::Types::Primitive]
    # @param type_validator [SmartCore::Types::Primitive::NilableValidator]
    # @param type_caster [SmartCore::Types::Caster]
    # @return [SmartCore::Type::Primitive]
    #
    # @api private
    # @since 0.1.0
    # @version 0.3.0
    def build_type(type, type_validator, type_caster)
      Class.new(type.class).new(
        type.name,
        type.category,
        type_validator,
        type_caster,
        type.runtime_attributes_checker,
        *type.runtime_attributes
      )
    end
  end
end
