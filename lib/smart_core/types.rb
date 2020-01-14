# frozen_string_literal: true

require 'smart_core'

# @api public
# @since 0.1.0
module SmartCore::Types
  require_relative 'types/version'
  require_relative 'types/errors'
end

class SmartCore; end
class SmartCore::Types; end
class SmartCore::Types::Primitive end
class SmartCore::Types::Value < SmartCore::Types::Primitive; end
class SmartCore::Types::Struct; end
class SmartCore::Types::Collection; end
class SmartCore::Types::Interface; end

  # 1. проверять, что является таким-то инстансом
  # 2. проверять, что является таким-то типом
  # 3. проверять, что интерфейс совпадает и заимплемечен (респонд_ту проверочка)
  # 4. уметь проверять хэши
  # 5. уметь проверять массивы
  # 6. уметь проверять что хэш имеет такую-то схему
  # 7. уметь проверять что массив содержит только такие элементы или один из
  # 8. уметь проверять отдельные типы на условя (больше-меньше-равно)
  # 9. уметь проверять на опшионал (это когда значение либо нил либо тип) - можно имплементировать как Strict от суммы типов NilClass и String для примера
  # 10. имплементировать сумму типов (возможность суммировать типы)
  # 11. имплементировать Coercible-типы, которые не чекают, а приводят К типу
  # 12. предоставить инетрфейс для реализации своего типа
  # 13. у каждой проверялки можно вызвать метод-чекер (valid?() - чтобы вернуть булеан ИЛИ check() - чтобы упасть с эксепшном если что-то не так)
  # 14. каждый тип может быть енумом (тип со значением одного из)
  # 15. можно сделать простой енум-тип (это значит значение, которое просто одно из)

# class SmartCore::Types::Value::String; end
# class SmartCore::Types::Value::Symbol; end
# class SmartCore::Types::Value::Text; end
# class SmartCore::Types::Value::Integer; end
# class SmartCore::Types::Value::Float; end
# class SmartCore::Types::Value::Numeric; end
# class SmartCore::Types::Value::TrueValue; end
# class SmartCore::Types::Value::FalseValue; end
# class SmartCore::Types::Value::Boolean; end
# class SmartCore::Types::Value::Array; end
# class SmartCore::Types::Value::Hash; end
# class SmartCore::Types::Value::Enumerable; end
class SmartCore::Types::Struct::Object; end
class SmartCore::Types::Struct::Hash; end
class SmartCore::Types::Struct::Array; end
class SmartCore::Types::Struct::Enum; end
class SmartCore::Types::Collection::ArrayOf; end
class SmartCore::Types::Collection::HashOf; end
class SmartCore::Types::Interface::Instance; end
class SmartCore::Types::Interface::Static; end
class SmartCore::Custom; end

# class SimpleService < SmartCore::Operation
#   include SmartCore::Types::System(:T)
#   include SmartCore::Initializer

#   param :test, T::Value::String
#   option :lol, T::Value::String
# end

# SimpleService.new('test', lol: 123)

class SmartCore::Types::System
  module TypeDefinitionDSL
    def define_type(type_name, &definition)
      SmartCore::Types::Builder.new(self).define_type(type_name, &definition)
    end
  end
end

class SmartCore::Types::Builder
  class CheckerBuilder
    def initialize(expression)
      @expression = expressions
    end

    def build
      SmartCore::Types::Primitive::Checker.new(@expression)
    end
  end

  class CasterBuilder
    def initialize(expression)
      @expression = expressions
    end

    def build
      SmartCore::Types::Primitive::Caster.new(@expression)
    end
  end

  class Definitions
    def initialize
      @type_checker = nil
      @type_caster = nil
    end

    attr_reader :type_checker
    attr_reader :type_caster

    def define_checker(&checker)
      @type_checker = checker
    end

    def define_caster(&caster)
      @type_caster = caster
    end
  end

  def initialize(type_category)
    @type_category = type_category
  end

  def define_type(type_name, &definition)
    definitions = Definitions.new.tap { |d| d.instance_eval(&definition) }
    Class.new(type_category).new(definitions.type_checker, definitions.type_caster)
  end
end

class SmartCore::Types::Primitive
  attr_reader :checker
  protected :checker

  # @param checker [SmartCore::Types::Primitive::Checker]
  # @param casetr [SmartCore::Types::Primitive::Caster]
  def initialize(checker, caster)
    @checker = checker
    @caster = caster
  end

  def valid?(value)
    checker.call(value)
  end

  def cast(value)
    caster.call(value)
  end

  def |(another_type)
    SmartCore::Types::Primitive.new(
      SumChecker.new(checker.dup, another_type.checker.dup)
    )
  end

  def &(another_type)
    SmartCore::Types::Primitive.new(
      MulChecker.new(checker.dup, another_type.checker.dup)
    )
  end
end

class SmartCore::Types::Value
  extend SmartCore::Types::System::TypeDefinitionDSL
end


class SmartCore::Types::Primitive::Checker
  # @param checker [Proc]
  def initialize(checker)
    @checker = checker
  end

  def call(value)
    checker.call(value)
  end

  def dup
    self.class.new(checker).call
  end

  private

  attr_reader :checker
end

class SmartCore::Types::Primitive
  class SumChecker < Checker
    attr_reader :checkers

    private :checkers

    def initialize(*checkers)
      @checkers = checkers
    end

    # @param checkers [Array<SmartCore::Types::Primitive::Checker>]
    def call(value)
      checkers.any? { |checker| checker.call(value) }
    end

    def dup
      self.class.new(*checkers.map(&:dup))
    end
  end

  class MultChecker < Checker
    attr_reader :checkers

    private :checkers

    # @param checkers [Array<SmartCore::Types::Primitive::Checker>]
    def initialize(*checkers)
      @checkers = checkers
    end

    def call(value)
      checkers.all? { |checker| checker.call(vale) }
    end

    def dup
      self.class.new(*checkers.map(&:dup))
    end
  end
end

SmartCore::Types::Value.define_type(:String) do |type|
  type.define_checker { |value| value.is_a?(String) }
  type.define_caster  { |value| value.to_s }
end

puts SmartCore::Types::Value::String.valid?('test')
puts SmartCore::Types::Value::String.cast(123)


























