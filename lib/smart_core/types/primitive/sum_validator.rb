# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Types::Primitive::SumValidator
  require_relative 'sum_validator/result'

  # @param validators [Array<SmartCore::Types::Primitive::Validator>]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize(*validators)
    @type = nil
    @validators = validators
  end

  # @param type [SmartCore::Types::Primitive]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def ___assign_type___(type)
    @type = type
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.2.0
  def valid?(value)
    validators.any? { |validator| validator.valid?(value) }
  end

  # @param value [Any]
  # @return [SmartCore::Types::Primitive::SumValidator::Result]
  #
  # @api private
  # @since 0.2.0
  def validate(value)
    final_result = SmartCore::Engine::Atom.new.tap do |result|
      validators.each do |validator|
        result.swap { validator.validate(value) }
        break if result.value.success?
      end
    end

    SmartCore::Types::Primitive::SumValidator::Result.new(
      type, final_result.value, final_result.value.invariant_errors
    )
  end

  # @param value [Any]
  # @return [void]
  #
  # @raise [SmartCore::Types::TypeError]
  #
  # @api private
  # @since 0.2.0
  def validate!(value)
    return if valid?(value)
    raise(SmartCore::Types::TypeError, 'Invalid type')
  end

  private

  # @return [SmartCore::Types::Primitive]
  #
  # @api private
  # @since 0.2.0
  attr_reader :type

  # @return [Array<SmartCore::Types::Primitive::Validator>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :validators
end
