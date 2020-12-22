# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Any' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      integer = 1
      float = 2.5
      null = nil
      symbol = :test
      string = 'test'
      mod = Module
      mod_instance = Module.new
      klass = Class
      klass_instance = Class.new
      basic_object = BasicObject.new
      object = Object.new
      hash_instance = {}
      arr_instance = []
      time = Time.new
      date = Date.new
      date_time = DateTime.new
      minus_infinity = -Float::INFINITY
      plus_infinity = Float::INFINITY
      nan = Float::NAN
      date_infinity = Date::Infinity
      date_time_infinity = DateTime::Infinity
      big_decimal = BigDecimal('123.456')

      expect(type.cast(integer)).to eq(integer).and be_a(::Integer)
      expect(type.cast(float)).to eq(float).and be_a(::Float)
      expect(type.cast(null)).to eq(null).and be_a(::NilClass)
      expect(type.cast(symbol)).to eq(symbol).and be_a(::Symbol)
      expect(type.cast(string)).to eq(string).and be_a(::String)
      expect(type.cast(mod)).to eq(mod).and be_a(::Class)
      expect(type.cast(mod_instance)).to eq(mod_instance).and be_a(::Module)
      expect(type.cast(klass)).to eq(klass).and be_a(::Class)
      expect(type.cast(klass_instance)).to eq(klass_instance).and be_a(::Class)
      expect(type.cast(object)).to eq(object).and be_a(::Object)
      expect(type.cast(basic_object)).to eq(basic_object)
      expect(type.cast(hash_instance)).to eq(hash_instance).and be_a(::Hash)
      expect(type.cast(arr_instance)).to eq(arr_instance).and be_a(::Array)
      expect(type.cast(time)).to eq(time).and be_a(::Time)
      expect(type.cast(date)).to eq(date).and be_a(::Date)
      expect(type.cast(date_time)).to eq(date_time).and be_a(::DateTime)
      expect(type.cast(minus_infinity)).to eq(minus_infinity).and be_a(::Float)
      expect(type.cast(plus_infinity)).to eq(plus_infinity).and be_a(::Float)
      expect(type.cast(nan).object_id).to eq(nan.object_id)
      expect(type.cast(date_infinity)).to eq(date_infinity).and be_a(::Class)
      expect(type.cast(date_time_infinity)).to eq(date_time_infinity).and be_a(::Class)
      expect(type.cast(big_decimal)).to eq(big_decimal).and be_a(::BigDecimal)
    end
  end

  shared_examples 'type checking' do
    specify 'type-checking' do
      expect(type.valid?(1)).to eq(true)
      expect(type.valid?(2.3)).to eq(true)
      expect(type.valid?(nil)).to eq(true)
      expect(type.valid?(:test)).to eq(true)
      expect(type.valid?('test')).to eq(true)
      expect(type.valid?(Module)).to eq(true)
      expect(type.valid?(Module.new)).to eq(true)
      expect(type.valid?(Class)).to eq(true)
      expect(type.valid?(Class.new)).to eq(true)
      expect(type.valid?(Object.new)).to eq(true)
      expect(type.valid?(BasicObject.new)).to eq(true)
      expect(type.valid?({})).to eq(true)
      expect(type.valid?([])).to eq(true)
      expect(type.valid?(Time.new)).to eq(true)
      expect(type.valid?(Date.new)).to eq(true)
      expect(type.valid?(DateTime.new)).to eq(true)
      expect(type.valid?(-Float::INFINITY)).to eq(true)
      expect(type.valid?(Float::INFINITY)).to eq(true)
      expect(type.valid?(Float::NAN)).to eq(true)
      expect(type.valid?(Date::Infinity)).to eq(true)
      expect(type.valid?(DateTime::Infinity)).to eq(true)
      expect(type.valid?(BigDecimal('123.456'))).to eq(true)
    end
  end

  shared_examples 'type validation' do
    specify 'type-validation' do
      expect { type.validate!(1) }.not_to raise_error
      expect { type.validate!(2.3) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error
      expect { type.validate!(:test) }.not_to raise_error
      expect { type.validate!('test') }.not_to raise_error
      expect { type.validate!(Module) }.not_to raise_error
      expect { type.validate!(Module.new) }.not_to raise_error
      expect { type.validate!(Class) }.not_to raise_error
      expect { type.validate!(Class.new) }.not_to raise_error
      expect { type.validate!(Object.new) }.not_to raise_error
      expect { type.validate!(BasicObject.new) }.not_to raise_error
      expect { type.validate!({}) }.not_to raise_error
      expect { type.validate!([]) }.not_to raise_error
      expect { type.validate!(Time.new) }.not_to raise_error
      expect { type.validate!(Date.new) }.not_to raise_error
      expect { type.validate!(DateTime.new) }.not_to raise_error
      expect { type.validate!(-Float::INFINITY) }.not_to raise_error
      expect { type.validate!(Float::INFINITY) }.not_to raise_error
      expect { type.validate!(Float::NAN) }.not_to raise_error
      expect { type.validate!(Date::Infinity) }.not_to raise_error
      expect { type.validate!(DateTime::Infinity) }.not_to raise_error
      expect { type.validate!(BigDecimal('123.456')) }.not_to raise_error
    end
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::Any() }

    include_examples 'type casting'
    include_examples 'type checking'
    include_examples 'type validation'
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Any }

    include_examples 'type casting'
    include_examples 'type checking'
    include_examples 'type validation'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Any.nilable }

    include_examples 'type casting'
    include_examples 'type checking'
    include_examples 'type validation'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::Any().nilable }

    include_examples 'type casting'
    include_examples 'type checking'
    include_examples 'type validation'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::Any(1) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
