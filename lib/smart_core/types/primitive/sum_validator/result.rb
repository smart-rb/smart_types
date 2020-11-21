# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Types::Primitive::SumValidator::Result
  # @return [Array]
  #
  # @api private
  # @since 0.2.0
  NO_INVARIANT_ERRORS = [].freeze

  # @return [SmartCore::Types::Primitive]
  #
  # @api public
  # @since 0.2.0
  attr_reader :type

  # @return concrete_validation_result [
  #   SmartCore::Types::Primitive::Validator::Result,
  #   SmartCore::Types::Primitive::SumValidator::Result,
  #   SmartCore::Types::Primitive::MultValidator::Result,
  #   SmartCore::Types::Primitive::NilableValidator::Result
  # ]
  #
  # @api private
  # @since 0.2.0
  attr_reader :concrete_validation_result

  # @return [Array<String>]
  #
  # @api public
  # @since 0.2.0
  attr_reader :invariant_errors
  alias_method :errors, :invariant_errors
  alias_method :error_codes, :invariant_errors

  # @param type [SmartCore::Types::Primitive]
  # @param concrete_validation_result [
  #   Boolean, (TEMPORARY)
  #   SmartCore::Types::Primitive::Validator::Result,
  #   SmartCore::Types::Primitive::SumValidator::Result,
  #   SmartCore::Types::Primitive::MultValidator::Result,
  #   SmartCore::Types::Primitive::NilableValidator::Result
  # ]
  # @param invariant_errors [Array<String>]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize(type, concrete_validation_result, invariant_errors = NO_INVARIANT_ERRORS.dup)
    @type = type
    @concrete_validation_result = concrete_validation_result
    @invariant_errors = invariant_errors.dup.tap(&:freeze)
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.2.0
  def valid_invariants?
    # NOTE: at this moment type sum does not support invariant checking
    # TODO (0.x.0):
    #   concrete_validation_result.valid_invariants?
    true
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.2.0
  def is_valid_check
    # NOTE: at this moment type sum does not support invariant checking
    # TODO (0.x.0):
    #   concrete_validation_result.is_valid_check
    concrete_validation_result
  end
  alias_method :valid_check?, :is_valid_check

  # @return [Boolean]
  #
  # @api public
  # @since 0.2.0
  def success?
    # NOTE: at this moment type sum does not support invariant checking
    # TODO (0.x.0):
    #   concrete_validation_result.success?
    concrete_validation_result
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.2.0
  def failure?
    # NOTE: at this moment type sum does not support invariant checking
    # TODO (0.x.0):
    #   concrete_validation_result.failure?
    !success?
  end
end
