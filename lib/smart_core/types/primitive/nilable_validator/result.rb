# frozen_string_literal: true

# @api private
# @since 0.3.0
class SmartCore::Types::Primitive::NilableValidator::Result
  # @return [Array]
  #
  # @api private
  # @since 0.3.0
  NO_INVARIANT_ERRORS = [].freeze

  # @return [SmartCore::Types::Primitive]
  #
  # @api public
  # @since 0.3.0
  attr_reader :type

  # @return [Any]
  #
  # @api public
  # @since 0.3.0
  attr_reader :checked_value
  alias_method :value, :checked_value

  # @param type [SmartCore::Types::Primitive]
  # @param checked_value [Any]
  # @return [void]
  #
  # @api private
  # @since 0.3.0
  def initialize(type, checked_value)
    @type = type
    @checked_value = checked_value
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.3.0
  def is_valid_check
    true
  end
  alias_method :valid_check?, :is_valid_check

  # @return [Array]
  #
  # @api public
  # @since 0.3.0
  def invariant_errors
    NO_INVARIANT_ERRORS
  end
  alias_method :errors, :invariant_errors
  alias_method :error_codes, :invariant_errors

  # @return [Boolean]
  #
  # @api public
  # @since 0.3.0
  def valid_invariants?
    true
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.3.0
  def success?
    true
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.3.0
  def failure?
    false
  end
end
