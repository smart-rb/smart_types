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
    final_result = SmartCore::Engine::Atom.new.tap do |result|
      validators.each do |validator|
        result.swap { validator.validate(value) }
        break if result.value.success?
      end
    end

    SmartCore::Types::Primitive::MultValidator::Result.new(
      type, final_result.value, final_result.value.invariant_errors
    )
  end
end
