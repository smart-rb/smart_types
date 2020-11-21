# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Types::Primitive::Validator::Result
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

  # @return [Boolean]
  #
  # @api public
  # @since 0.2.0
  attr_reader :is_valid_check
  alias_method :valid_check?, :is_valid_check

  # @return [Any]
  #
  # @api public
  # @since 0.2.0
  attr_reader :checked_value
  alias_method :value, :checked_value

  # @return [Array<String>]
  #
  # @api public
  # @since 0.2.0
  attr_reader :invariant_errors
  alias_method :errors, :invariant_errors
  alias_method :error_codes, :invariant_errors

  # @param type [SmartCore::Types::Primitive]
  # @param checked_value [Any]
  # @param is_valid_check [Boolean]
  # @param invariant_errors [Array<String>]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def initialize(type, checked_value, is_valid_check, invariant_errors = NO_INVARIANT_ERRORS.dup)
    @type = type
    @checked_value = checked_value
    @is_valid_check = is_valid_check
    @invariant_errors = invariant_errors.tap(&:freeze)
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.2.0
  def valid_invariants?
    invariant_errors.empty?
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.2.0
  def success?
    valid_check? && invariant_errors.empty?
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.2.0
  def failure?
    !success?
  end
end
