# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Types::Primitive::NilableFactory
  class << self
    # @param type [SmartCore::Types::Primitive]
    # @return [SmartCore::Type::Primitive]
    #
    # @api private
    # @since 0.1.0
    def create_type(type)
      type_checker = build_type_checker(type)
      type_caster = build_type_caster(type)
      build_type(type, type_checker, type_caster)
    end

    private

    # @param type [SmartCore::Types::Primitive]
    # @return [SmartCore::Types::Primitive::NilableChecker]
    #
    # @api private
    # @since 0.1.0
    def build_type_checker(type)
      SmartCore::Types::Primitive::NilableChecker.new(type.checker)
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
    # @param type_checker [SmartCore::Types::Primitive::NilableChecker]
    # @param type_caster [SmartCore::Types::Caster]
    # @return [SmartCore::Type::Primitive]
    #
    # @api private
    # @since 0.1.0
    def build_type(type, type_checker, type_caster)
      Class.new(type.class).new(type_checker, type_caster)
    end
  end
end
