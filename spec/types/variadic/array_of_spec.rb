# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Variadic::ArrayOf' do
  describe 'runtime-based behavior' do
    specify 'fails on non-class objects (should work only with classes)' do
      expect do
        SmartCore::Types::Variadic::ArrayOf(123)
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)

      expect do
        SmartCore::Types::Variadic::ArrayOf('test', 123)
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)

      expect do
        SmartCore::Types::Variadic::ArrayOf(::Symbol, 123)
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)

      expect do
        SmartCore::Types::Variadic::ArrayOf(Module.new, ::String)
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)
    end

    specify 'requires type list (runtime attributes)' do
      expect do
        SmartCore::Types::Variadic::ArrayOf()
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)

      expect { SmartCore::Types::Variadic::ArrayOf(::String, ::Integer) }.not_to raise_error
    end
  end

  describe 'logic' do
    specify 'type-casting (as Array)' do
      type = SmartCore::Types::Variadic::ArrayOf(::Object)
      nilable_type = type.nilable
      object = Object.new
      array = [Object.new, Object.new]
      expect(type.cast(object)).to eq([object])
      expect(type.cast(array)).to eq(array)
      expect(type.cast(nil)).to eq([])

      expect(nilable_type.cast(object)).to eq([object])
      expect(nilable_type.cast(array)).to eq(array)
      expect(nilable_type.cast(nil)).to eq([])
    end

    # rubocop:disable Layout/LineLength
    specify 'type-checking / type-validation' do
      type = SmartCore::Types::Variadic::ArrayOf(::String, ::Symbol, ::Array, ::Hash)
      nilable_type = type.nilable

      aggregate_failures 'non-nilable array_of (String, Symbol, Array, Hash)' do
        expect(type.valid?(['test', :test, [], { test: :test }])).to eq(true)
        expect(type.valid?(%w[test test2])).to eq(true)
        expect(type.valid?([%i[key value], ['test', :test], [123]])).to eq(true)
        expect(type.valid?(nil)).to eq(false)
        expect(type.valid?([nil, 'test'])).to eq(false)
        expect(type.valid?(Object.new)).to eq(false)
        expect(type.valid?(['test', BasicObject.new])).to eq(false)
        expect { type.validate!(['test', :test, [], { test: :test }]) }.not_to raise_error
        expect { type.validate!(%w[test test2]) }.not_to raise_error
        expect { type.validate!([%i[key value], ['test', :test], [123]]) }.not_to raise_error
        expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
        expect { type.validate!([nil, 'test']) }.to raise_error(SmartCore::Types::TypeError)
        expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
        expect { type.validate!(['test', BasicObject.new]) }.to raise_error(SmartCore::Types::TypeError)
      end

      aggregate_failures 'nilable array_of (String, Symbol, Array, Hash)' do
        expect(nilable_type.valid?(['test', :test, [], { test: :test }])).to eq(true)
        expect(nilable_type.valid?(%w[test test2])).to eq(true)
        expect(nilable_type.valid?([%i[key value], ['test', :test], [123]])).to eq(true)
        expect(nilable_type.valid?(nil)).to eq(true)
        expect(nilable_type.valid?([nil, 'test'])).to eq(false)
        expect(nilable_type.valid?(Object.new)).to eq(false)
        expect(nilable_type.valid?(['test', BasicObject.new])).to eq(false)
        expect { nilable_type.validate!(['test', :test, [], { test: :test }]) }.not_to raise_error
        expect { nilable_type.validate!(%w[test test2]) }.not_to raise_error
        expect { nilable_type.validate!([%i[key value], ['test', :test], [123]]) }.not_to raise_error
        expect { nilable_type.validate!(nil) }.not_to raise_error
        expect { nilable_type.validate!([nil, 'test']) }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_type.validate!(['test', BasicObject.new]) }.to raise_error(SmartCore::Types::TypeError)
      end

      no_any_type = SmartCore::Types::Variadic::ArrayOf
      nillable_no_any_type = no_any_type.nilable

      aggregate_failures 'example of no-one-type-is-supported collection (non-nilable)' do
        expect(no_any_type.valid?('test')).to eq(false)
        expect(no_any_type.valid?(Object.new)).to eq(false)
        expect(no_any_type.valid?([Object.new, Object.new])).to eq(false)
        expect(no_any_type.valid?(BasicObject.new)).to eq(false)
        expect(no_any_type.valid?(nil)).to eq(false)
      end

      aggregate_failures 'example of no-one-type-is-supported collection (nilable)' do
        expect(nillable_no_any_type.valid?('test')).to eq(false)
        expect(nillable_no_any_type.valid?(Object.new)).to eq(false)
        expect(nillable_no_any_type.valid?([Object.new, Object.new])).to eq(false)
        expect(nillable_no_any_type.valid?(BasicObject.new)).to eq(false)
        expect(nillable_no_any_type.valid?(nil)).to eq(true)
      end
    end
    # rubocop:enable Layout/LineLength
  end
end
