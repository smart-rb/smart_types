# frozen_string_literal: true

# @api private
# @since 0.3.0
class SmartCore::Types::Primitive::InvariantControl::Single::Result
  # @return [SmartCore::Types::Primitive::InvariantControl::Single]
  #
  # @api private
  # @since 0.3.0
  attr_reader :invariant

  # @return [Any]
  #
  # @api private
  # @since 0.3.0
  attr_reader :checked_value

  # @param invariant [SmartCore::Types::Primitive::InvariantControl::Single]
  # @param checked_value [Any]
  # @param is_valid_check [Boolean]
  # @return [void]
  #
  # @api private
  # @since 0.3.0
  def initialize(invariant, checked_value, is_valid_check)
    @invariant = invariant
    @checked_value = checked_value
    @is_valid_check = is_valid_check
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.3.0
  def success?
    is_valid_check
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.3.0
  def failure?
    !success?
  end

  # @return [Array<String>]
  #
  # @api private
  # @since 0.3.0
  def error_codes
    success? ? [] : [invariant.name]
  end

  private

  # @return [Boolean]
  #
  # @api private
  # @since 0.3.0
  attr_reader :is_valid_check
  alias_method :valid_check?, :is_valid_check
end
