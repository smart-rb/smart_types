# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Types::Primitive::Validator
  require_relative 'validator/result'

  # @return [SmartCore::Type::Primitive]
  #
  # @api private
  # @since 0.2.0
  attr_reader :type

  # @return [SmartCore::Types::Primitive::Checker]
  #
  # @api private
  # @since 0.2.0
  attr_reader :type_checker

  # @return [SmartCore::Types::Primitive::InvariantControl]
  #
  # @api private
  # @since 0.2.0
  attr_reader :invariant_control

  # @param type_checker [
  #   SmartCore::Types::Primitive::Checker,
  #   SmartCore::Types::Primitive::MultChecker,
  #   SmartCore::Types::Primitive::SumChecker
  # ]
  # @param invariant_control [SmartCore::Types::Primitive::InvariantControl]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize(type_checker, invariant_control)
    @type = nil
    @type_checker = type_checker
    @invariant_control = invariant_control
  end

  # @param type [SmartCore::Types::Primitive]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def ___assign_type___(type)
    @type = type
  end

  # @param value [Any]
  # @return [Boolean]
  #
  # @api private
  # @since 0.2.0
  def valid?(value)
    validate(value).success?
  end

  # @param value [Any]
  # @return [SmartCore::Types::Primitive::Validator::Result]
  #
  # @api private
  # @since 0.2.0
  def validate(value)
    checker_result = type_checker.call(value) # => Boolean
    return Result.new(type, value, checker_result) unless checker_result
    invariant_result = invariant_control.check(value)
    invariant_errors = invariant_result.invariant_errors.map { |error| "#{type.name}.#{error}" }
    Result.new(type, value, checker_result, invariant_errors)
  end

  # @param value [Any]
  # @return [void]
  #
  # @raise [SmartCore::Types::TypeError]
  #
  # @api private
  # @since 0.2.0
  def validate!(value)
    return if validate(value).success?
    raise(SmartCore::Types::TypeError, 'Invalid type')
  end
end
