# frozen_string_literal: true

# @api private
# @since 0.3.0
class SmartCore::Types::Primitive::NilableValidator
  require_relative 'nilable_validator/result'

  # @param validator [
  #   SmartCore::Types::Primitive::Validator,
  #   SmartCore::Types::Primitive::SumValidator,
  #   SmartCore::Types::Primitive::MultValidator,
  #   SmartCore::Types::Primitive::NilableValidator
  # ]
  # @return [void]
  #
  # @api private
  # @since 0.3.0
  def initialize(validator)
    @type = nil
    @validator = validator
  end

  # @param type [SmartCore::Types::Primitive]
  # @return [void]
  #
  # @api private
  # @since 0.3.0
  def ___assign_type___(type)
    @type = type
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.3.0
  def valid?(value)
    value == nil ? true : validator.valid?(value)
  end

  # @param value [Any]
  # @return [SmartCore::Types::Primitive::Validator::Result]
  # @return [SmartCore::Types::Primitive::SumValidator::Result]
  # @return [SmartCore::Types::Primitive::MultValidator::Result]
  # @return [SmartCore::Types::Primitive::NilableValidator::Result]
  #
  # @api private
  # @since 0.3.0
  def validate(value)
    return Result.new(type, value) if value == nil
    validator.validate(value)
  end

  # @param value [Any]
  # @return [void]
  #
  # @raise [SmartCore::Types::TypeError]
  #
  # @api private
  # @since 0.3.0
  def validate!(value)
    return if valid?(value)
    raise(SmartCore::Types::TypeError, 'Invalid type')
  end

  private

  # @return [SmartCore::Types::Primitive]
  #
  # @api private
  # @since 0.3.0
  attr_reader :type

  # @return [
  #   SmartCore::Types::Primitive::Validator,
  #   SmartCore::Types::Primitive::SumValidator,
  #   SmartCore::Types::Primitive::MultValidator,
  #   SmartCore::Types::Primitive::NilableValidator
  # ]
  #
  # @api private
  # @since 0.3.0
  attr_reader :validator
end
