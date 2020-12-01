# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.2.0
class SmartCore::Types::Primitive::Factory::DefinitionContext
  class << self
    # @param name [String, Symbol]
    # @param definition [Block]
    # @return [void]
    #
    # @api private
    # @since 0.2.0
    def validate_invariant_attributes!(name, &definition)
      unless block_given?
        raise(SmartCore::Types::ArgumentError, 'No invariant block')
      end

      unless name.is_a?(::String) || name.is_a?(::Symbol)
        raise(SmartCore::Types::ArgumentError, <<~ERROR_MESSAGE)
          Invariant name should be a type of string or symbol.
        ERROR_MESSAGE
      end

      if name == '' || name == :""
        raise(SmartCore::Types::ArgumentError, <<~ERROR_MESSAGE)
          Invariant name can not be empty.
        ERROR_MESSAGE
      end
    end

    # @param chain_name [String, Symbol]
    # @param definition [Block]
    # @return [void]
    #
    # @api private
    # @since 0.3.0
    def validate_invariant_chain_attributes!(chain_name, &definition)
      unless block_given?
        raise(SmartCore::Types::ArgumentError, 'No invariant chain block')
      end

      unless chain_name.is_a?(::String) || chain_name.is_a?(::Symbol)
        raise(SmartCore::Types::ArgumentError, <<~ERROR_MESSAGE)
          Invariant chain name should be a type of string or symbol.
        ERROR_MESSAGE
      end

      if chain_name == '' || chain_name == :""
        raise(SmartCore::Types::ArgumentError, <<~ERROR_MESSAGE)
          Invariant chain name can not be empty.
        ERROR_MESSAGE
      end
    end
  end

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
  # @since 0.2.0
  attr_reader :type_invariant_chains

  # @return [Hash<String,Proc>]
  #
  # @api private
  # @since 0.2.0
  attr_reader :type_invariants

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.2.0
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
  # @version 0.2.0
  def define_checker(&checker)
    thread_safe do
      raise(SmartCore::Types::ArgumentError, 'No checker definition block') unless block_given?
      @type_checker = checker
    end
  end

  # @param caster [Block]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  # @version 0.2.0
  def define_caster(&caster)
    thread_safe do
      raise(SmartCore::Types::ArgumentError, 'No caster definition block') unless block_given?
      @type_caster = caster
    end
  end

  # @param chain_name [String, Symbol]
  # @param definitions [Block]
  # @return [void]
  #
  # @api public
  # @since 0.2.0
  def invariant_chain(chain_name, &definitions)
    thread_safe do
      self.class.validate_invariant_chain_attributes!(chain_name, &definitions)
      @type_invariant_chains[chain_name.to_s] << definitions
    end
  end

  # @param name [String, Symbol]
  # @param definition [Block]
  # @return [void]
  #
  # @api public
  # @since 0.2.0
  def invariant(name, &definition)
    thread_safe do
      self.class.validate_invariant_attributes!(name, &definition)
      @type_invariants[name.to_s] = definition
    end
  end

  private

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.2.0
  def thread_safe(&block)
    @definition_lock.synchronize(&block)
  end
end
