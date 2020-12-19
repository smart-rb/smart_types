# frozen_string_literal: true

# @api private
# @since 0.3.0
class SmartCore::Types::Primitive::RuntimeAttributesChecker
  # @return [Proc]
  #
  # @api private
  # @since 0.3.0
  ATTRIBUTES_IS_NOT_ALLOWED_CHECKER = proc do |attrs|
    attrs.empty? || raise(SmartCore::Types::RuntimeAttriburtesUnsupportedError, <<~ERROR_MESSAGE)
      This type has no support for runtime attributes.
    ERROR_MESSAGE
  end.freeze

  # @param attributes_checker [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.3.0
  def initialize(attributes_checker)
    @type = nil
    @attributes_checker = attributes_checker || ATTRIBUTES_IS_NOT_ALLOWED_CHECKER
  end

  # @param type [SmartCore::Types::Primitive]
  # @return [SmartCore::Types::Primitive::RuntimeAttributesChecker]
  #
  # @api private
  # @since 0.3.0
  def ___copy_for___(type)
    self.class.new(attributes_checker).tap do |instance_copy|
      instance_copy.___assign_type___(type)
    end
  end

  # @param type [SmartCore::Types::Primitive]
  # @return [void]
  #
  # @api private
  # @since 0.3.0
  def ___assign_type___(type)
    @type = type
  end

  # @param runtime_attributes [Array<Any>]
  # @return [void]
  #
  # @raise [SmartCore::Types::IncorrectRuntimeAttributesError]
  #
  # @api private
  # @since 0.3.0
  def check!(runtime_attributes)
    unless !!attributes_checker.call(runtime_attributes)
      # TODO (0.x.0):
      #   Full type name (with type category; and delegated to the type object).
      #   (main problem: sum and mult types has no type name and type category)
      raise(SmartCore::Types::IncorrectRuntimeAttributesError, <<~ERROR_MESSAGE)
        Incorrect runtime attributes for #{type.name}.
      ERROR_MESSAGE
    end
  end

  private

  # @return [SmartCore::Types::Primitive]
  #
  # @api private
  # @since 0.3.0
  attr_reader :type

  # @return [Proc]
  #
  # @api private
  # @since 0.3.0
  attr_reader :attributes_checker
end
