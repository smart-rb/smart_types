# frozen_string_literal: true

# @api private
# @since 0.2.0
class SmartCore::Types::Primitive::InvariantControl::Chain
  require_relative 'chain/result'

  # @return [String]
  #
  # @api private
  # @since 0.2.0
  attr_reader :name

  # @param name [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(name)
    @name = name.dup.tap(&:freeze)
    @invariants = []
  end

  # @param invariant [SmartCore::Types::Primitive::InvariantControl::Single]
  # @return [void]
  #
  # @api private
  # @since 0.2.0
  def add_invariant(invariant)
    invariants << invariant
  end

  # @param value [Any]
  # @return [SmartCore::Types::Primitive::InvariantControl::Chain::Result]
  #
  # @api private
  # @since 0.2.0
  def check(value)
    invariant_results = [].tap do |results|
      invariants.each do |invariant|
        result = invariant.check(value).tap { |res| results << res }
        break if result.failure?
      end
    end

    SmartCore::Types::Primitive::InvariantControl::Chain::Result.new(
      self, value, invariant_results
    )
  end

  private

  # @return [Array<SmartCore::Types::Primitive::InvariantControl::Single>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :invariants
end
