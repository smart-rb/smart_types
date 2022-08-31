# frozen_string_literal: true

# @api private
# @since 0.3.0
module SmartCore::Types::Primitive::Factory::RuntimeTypeBuilder
  class << self
    # @param type_name [String, Symbol]
    # @param type_category [Class<SmartCore::Types::Primitive>]
    # @param runtime_attributes [Array<Any>]
    # @return [SmartCore::Types::Primitive]
    #
    # @api private
    # @since 0.3.0
    def build_with_runtime(type_name, type_category, runtime_attributes)
      type = type_category.const_get(type_name)
      type.runtime_attributes_checker.check!(runtime_attributes)

      type.clone.tap do |type_with_custom_runtime|
        type_with_custom_runtime.instance_variable_set(
          :@runtime_attributes, runtime_attributes.freeze
        )
      end
    end

    # @param new_instance [SmartCore::Types::Primitive]
    # @param cloneable_instance [SmartCore::Types::Primitive]
    # @return [void]
    #
    # @api private
    # @since 0.3.0
    # @version 0.7.1
    # rubocop:disable Metrics/AbcSize, Layout/LineLength
    public def initialize_clone(new_instance, cloneable_instance)
      name_clone = cloneable_instance.instance_variable_get(:@name)
      category_clone = cloneable_instance.instance_variable_get(:@category)
      validator_clone = cloneable_instance.instance_variable_get(:@validator).___copy_for___(new_instance)
      caster_clone = cloneable_instance.instance_variable_get(:@caster)
      runtime_attributes_clone = cloneable_instance.instance_variable_get(:@runtime_attributes).clone
      runtime_attributes_checker_clone = cloneable_instance.instance_variable_get(:@runtime_attributes_checker).___copy_for___(new_instance)
      lock_clone = SmartCore::Engine::Lock.new
      nilable_clone = nil

      new_instance.instance_variable_set(:@name, name_clone)
      new_instance.instance_variable_set(:@category, category_clone)
      new_instance.instance_variable_set(:@validator, validator_clone)
      new_instance.instance_variable_set(:@caster, caster_clone)
      new_instance.instance_variable_set(:@runtime_attributes, runtime_attributes_clone)
      new_instance.instance_variable_set(:@runtime_attributes_checker, runtime_attributes_checker_clone)
      new_instance.instance_variable_set(:@lock_clone, lock_clone)
      new_instance.instance_variable_set(:@nilable, nilable_clone)
    end
    # rubocop:enable Metrics/AbcSize, Layout/LineLength
  end
end
