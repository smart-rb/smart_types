# frozen_string_literal: true

# @api private
# @since 0.3.0
module SmartCore::Types::Primitive::ParametrizedFactory
  class << self
    # @param type [SmartCore::Types::Primitive]
    # @param params [Array<Any>]
    # @return [SmartCore::Types::Primitive]
    #
    # @api private
    # @since 0.3.0
    def create_type(type, params)
      type_checker = type.validator.type_checker
      type_caster = type.caster
      type_invariant_control = type.validator.invariant_control
      assign_type_checker_params(type_checker, params)
      assign_type_caster_params(type_caster, params)
      type_validator = build_type_validator(type_checker, type_invariant_control)
      build_type(type_validator, type_caster).tap do |result_type|
        assign_type_validator(result_type, type_validator)
      end
    end

    private

    # @param type_checker [SmartCore::Types::Primitive::Checker]
    # @param type_invariant_control [SmartCore::Types::Primitive::InvariantControl]
    # @return [void]
    #
    # @api private
    # @since 0.3.0
    def build_type_validator(type_checker, type_invariant_control)
      SmartCore::Types::Primitive::Validator.new(type_checker, type_invariant_control)
    end

    # @param type_checker [SmartCore::Types::Primitive::Checker]
    # @param params [Array<Any>]
    # @return [void]
    #
    # @api private
    # @since 0.3.0
    def assign_type_checker_params(type_checker, params)
      type_checker.___assign_params___(params)
    end

    # @param type_caster [SmartCore::Types::Primitive::Caster]
    # @param params [Array<Any>]
    # @return [void]
    #
    # @api private
    # @since 0.3.0
    def assign_type_caster_params(type_caster, params)
      type_caster.___assign_params___(params)
    end

    # @param type [SmartCore::Types::Primitive]
    # @param type_validator [SmartCore::Types::Primitive::Validator]
    # @return [void]
    #
    # @api private
    # @since 0.3.0
    def assign_type_validator(type, type_validator)
      type_validator.___assign_type___(type)
    end

    # @param type_validator [SmartCore::Types::Primitive::Validator]
    # @param type_caster [SmartCore::Types::Primitive::Caster]
    # @return [SmartCore::Types::Primitive]
    #
    # @api private
    # @since 0.3.0
    def build_type(type_validator, type_caster)
      SmartCore::Types::Primitive.new(nil, type_validator, type_caster)
    end
  end
end
