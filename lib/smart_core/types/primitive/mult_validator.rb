# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Types::Primitive::MultValidator < SmartCore::Types::Primitive::SumValidator
  require_relative 'mult_validator/result'

  # @param value [Any]
  # @return [Boolean]
  #
  # @api private
  # @since 0.2.0
  def valid?(value)
    validators.all? { |validator| validator.valid?(value) }
  end

  # @param value [Any]
  # @return [SmartCore::Types::Primitive::MultValidator::Result]
  #
  # @api private
  # @since 0.2.0
  def validate(value)
    result = validators.each_with_object(SmartCore::Engine::Atom.new) do |validator, final_result|
      final_result.swap { validator.validate(value) }
      break if final_result.value.failure?
    end

    SmartCore::Types::Primitive::MultValidator::Result.new(
      type, result.value, result.value.invariant_errors
    )
  end
end
