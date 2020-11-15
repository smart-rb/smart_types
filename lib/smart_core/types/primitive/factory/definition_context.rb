# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Types::Primitive::Factory::DefinitionContext
  # @return [Proc, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :type_checker

  # @return [Proc, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :type_caster

  # @return [Hash<String,Array<Proc>>]
  #
  # @api private
  # @since 0.3.0
  attr_reader :type_invariant_chains

  # @return [Hash<String,Proc>]
  #
  # @api private
  # @since 0.3.0
  attr_reader :type_invariants

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @type_invariant_chains = Hash.new { |h, k| h[k] = [] }
    @type_invariants = {}
    @type_checker = nil
    @type_caster = nil
    @definition_lock = SmartCore::Engine::Lock.new
  end

  # @param checker [Block]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def define_checker(&checker)
    thread_safe do
      raise(SmartCore::ArgumentError, 'No checker definition block') unless block_given?
      @type_checker = checker
    end
  end

  # @param caster [Block]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def define_caster(&caster)
    thread_safe do
      raise(SmartCore::ArgumentError, 'No caster definition block') unless block_given?
      @type_caster = caster
    end
  end

  # @param chain_name [String, Symbol]
  # @param invariant_chain [Block]
  # @return [void]
  #
  # @api public
  # @since 0.3.0
  def invariant_chain(chain_name, &invariant_chain)
    thread_safe do
      unless block_given?
        raise(SmartCore::ArgumentError, 'No invariant chain block')
      end

      unless chain_name.is_a?(::String) || chain_name.is_a?(::Symbol)
        raise(SmartCore::ArgumentError, 'Invariant chain name should be a type of string or symbol')
      end

      @type_invariant_chains[chain_name.to_s] << invariant_chain
    end
  end

  # @param name [String, Symbol]
  # @param invariant [Block]
  # @return [void]
  #
  # @api public
  # @since 0.3.0
  def invariant(name, &invariant)
    thread_safe do
      unless block_given?
        raise(SmartCore::ArgumentError, 'No invariant block')
      end

      unless name.is_a?(::String) || name.is_a?(::Symbol)
        raise(SmartCore::ArgumentError, 'Invariant name should be a type of string or symbol')
      end

      @type_invariants[name.to_s] = invariant
    end
  end

  private

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.3.0
  def thread_safe(&block)
    @definition_lock.synchronize(&block)
  end
end
