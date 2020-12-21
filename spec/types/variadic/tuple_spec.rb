# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Variadic::Tuple' do
  describe 'runtime-based behavior' do
    specify 'fails on non-class objects (should work only with classes)' do
      expect do
        SmartCore::Types::Variadic::Tuple(1, 5.0, :test)
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)

      expect do
        SmartCore::Types::Variadic::Tuple(::Symbol, 123)
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)

      expect do
        SmartCore::Types::Variadic::Tuple(Module.new, ::String)
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)
    end

    specify 'requires tuple signature (runtime attributes)' do
      expect do
        SmartCore::Types::Variadic::Tuple()
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)
    end
  end

  describe 'logic' do
    specify 'type-casting (does not supported)' do
      type = SmartCore::Types::Variadic::Tuple(::String, ::Integer, ::Time)
      expect { type.cast(['test', 1, Time.now]) }.to raise_error(
        SmartCore::Types::TypeCastingUnsupportedError
      )
    end

    # rubocop:disable Layout/LineLength
    specify 'type-checking / type-validation' do
      tuple_type = SmartCore::Types::Variadic::Tuple(::String, ::Float, ::Time)
      nilable_tuple_type = tuple_type.nilable

      aggregate_failures 'non-nilable (String, Float, Time) tuple' do
        expect(tuple_type.valid?(['test', 25.0, Time.now])).to eq(true)
        expect(tuple_type.valid?(['another-test', 7.11, Time.now])).to eq(true)
        expect { tuple_type.validate!(['test', 25.0, Time.now]) }.not_to raise_error
        expect { tuple_type.validate!(['another-test', 7.11, Time.now]) }.not_to raise_error

        expect(tuple_type.valid?([])).to eq(false)
        expect(tuple_type.valid?([:test, 5, Date.new])).to eq(false)
        expect(tuple_type.valid?([123, 456])).to eq(false)
        expect(tuple_type.valid?(nil)).to eq(false)
        expect(tuple_type.valid?(Set.new([]))).to eq(false)
        expect(tuple_type.valid?(Object.new)).to eq(false)
        expect(tuple_type.valid?(BasicObject.new)).to eq(false)
        expect(tuple_type.valid?('test')).to eq(false)

        expect { tuple_type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
        expect { tuple_type.validate!([:test, 5, Date.new]) }.to raise_error(SmartCore::Types::TypeError)
        expect { tuple_type.validate!([123, 456]) }.to raise_error(SmartCore::Types::TypeError)
        expect { tuple_type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
        expect { tuple_type.validate!(Set.new([])) }.to raise_error(SmartCore::Types::TypeError)
        expect { tuple_type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
        expect { tuple_type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      end

      aggregate_failures 'nilable (String, Float, Time) tuple' do
        expect(nilable_tuple_type.valid?(['test', 25.0, Time.now])).to eq(true)
        expect(nilable_tuple_type.valid?(['another-test', 7.11, Time.now])).to eq(true)
        expect(nilable_tuple_type.valid?(nil)).to eq(true)
        expect { nilable_tuple_type.validate!(['test', 25.0, Time.now]) }.not_to raise_error
        expect { nilable_tuple_type.validate!(['another-test', 7.11, Time.now]) }.not_to raise_error

        expect(nilable_tuple_type.valid?([])).to eq(false)
        expect(nilable_tuple_type.valid?([:test, 5, Date.new])).to eq(false)
        expect(nilable_tuple_type.valid?([123, 456])).to eq(false)
        expect(nilable_tuple_type.valid?(Set.new([]))).to eq(false)
        expect(nilable_tuple_type.valid?(BasicObject.new)).to eq(false)
        expect(nilable_tuple_type.valid?('test')).to eq(false)

        expect { nilable_tuple_type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_tuple_type.validate!([:test, 5, Date.new]) }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_tuple_type.validate!([123, 456]) }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_tuple_type.validate!(Set.new([])) }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_tuple_type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_tuple_type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      end

      simple_tuple_type = SmartCore::Types::Variadic::Tuple(::Time, ::Symbol)
      nilable_simple_tuple_type = simple_tuple_type.nilable

      aggregate_failures 'non-nilable (Time, Symbol) tuple' do
        expect(simple_tuple_type.valid?([Time.now, :test])).to eq(true)
        expect(simple_tuple_type.valid?([:test, Time.now])).to eq(false)
        expect(simple_tuple_type.valid?(nil)).to eq(false)

        expect { simple_tuple_type.validate!([Time.now, :test]) }.not_to raise_error
        expect { simple_tuple_type.validate!([:test, Time.now]) }.to raise_error(SmartCore::Types::TypeError)
        expect { simple_tuple_type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      end

      aggregate_failures 'nilable (Time, Symbol) tuple' do
        expect(nilable_simple_tuple_type.valid?([Time.now, :test])).to eq(true)
        expect(nilable_simple_tuple_type.valid?([:test, Time.now])).to eq(false)
        expect(nilable_simple_tuple_type.valid?(nil)).to eq(true)

        expect { nilable_simple_tuple_type.validate!([Time.now, :test]) }.not_to raise_error
        expect { nilable_simple_tuple_type.validate!([:test, Time.now]) }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_simple_tuple_type.validate!(nil) }.not_to raise_error
      end
    end
    # rubocop:enable Layout/LineLength
  end
end
