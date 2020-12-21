# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Protocol::InstanceOf' do
  describe 'runtime-based behavior' do
    specify 'fails on non-class objects (should work only with classes)' do
      expect do
        SmartCore::Types::Protocol::InstanceOf(123)
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)

      expect do
        SmartCore::Types::Protocol::InstanceOf('test', 123)
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)

      expect do
        SmartCore::Types::Protocol::InstanceOf(::Symbol, 123)
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)

      expect do
        SmartCore::Types::Protocol::InstanceOf(Module.new, ::String)
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)
    end

    specify 'requires type list (runtime attributes)' do
      expect do
        SmartCore::Types::Protocol::InstanceOf()
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)

      expect { SmartCore::Types::Protocol::InstanceOf(::String) }.not_to raise_error
    end
  end

  describe 'logic' do
    specify 'type-casting (does not supported)' do
      type = SmartCore::Types::Protocol::InstanceOf(::Time)
      expect { type.cast('2020-10-10') }.to raise_error(
        SmartCore::Types::TypeCastingUnsupportedError
      )

      nilable_type = type.nilable
      expect { nilable_type.cast('2020-10-10') }.to raise_error(
        SmartCore::Types::TypeCastingUnsupportedError
      )
    end

    # rubocop:disable Layout/LineLength
    specify 'type-checking / type-validation' do
      string_type = SmartCore::Types::Protocol::InstanceOf(::String, ::Symbol)
      nilable_string_type = string_type.nilable

      aggregate_failures 'example of string-types colelction (non-nilable)' do
        expect(string_type.valid?(:test)).to eq(true)
        expect(string_type.valid?('test')).to eq(true)
        expect(string_type.valid?(123)).to eq(false)
        expect(string_type.valid?(nil)).to eq(false)
        expect(string_type.valid?(Object.new)).to eq(false)
        expect(string_type.valid?(BasicObject.new)).to eq(false)
        expect { string_type.validate!(:test) }.not_to raise_error
        expect { string_type.validate!('test') }.not_to raise_error
        expect { string_type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
        expect { string_type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
        expect { string_type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
        expect { string_type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      end

      aggregate_failures 'example of string-types collection (nilable)' do
        expect(nilable_string_type.valid?(:test)).to eq(true)
        expect(nilable_string_type.valid?('test')).to eq(true)
        expect(nilable_string_type.valid?(nil)).to eq(true)
        expect(nilable_string_type.valid?(123)).to eq(false)
        expect(nilable_string_type.valid?(Object.new)).to eq(false)
        expect(nilable_string_type.valid?(BasicObject.new)).to eq(false)
        expect { nilable_string_type.validate!(:test) }.not_to raise_error
        expect { nilable_string_type.validate!('test') }.not_to raise_error
        expect { nilable_string_type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_string_type.validate!(nil) }.not_to raise_error
        expect { nilable_string_type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_string_type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      end

      numeric_type = SmartCore::Types::Protocol::InstanceOf(::Integer, ::Float)
      nilable_numeric_type = numeric_type.nilable

      aggregate_failures 'example of numeric-types collection (non-nilable)' do
        expect(numeric_type.valid?(:test)).to eq(false)
        expect(numeric_type.valid?('test')).to eq(false)
        expect(numeric_type.valid?(123)).to eq(true)
        expect(numeric_type.valid?(123.567)).to eq(true)
        expect(numeric_type.valid?(nil)).to eq(false)
        expect(numeric_type.valid?(Object.new)).to eq(false)
        expect(numeric_type.valid?(BasicObject.new)).to eq(false)
        expect { numeric_type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
        expect { numeric_type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
        expect { numeric_type.validate!(123) }.not_to raise_error
        expect { numeric_type.validate!(123.567) }.not_to raise_error
        expect { numeric_type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
        expect { numeric_type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
        expect { numeric_type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      end

      aggregate_failures 'example of numeric-types collection (nilable)' do
        expect(nilable_numeric_type.valid?(:test)).to eq(false)
        expect(nilable_numeric_type.valid?('test')).to eq(false)
        expect(nilable_numeric_type.valid?(Object.new)).to eq(false)
        expect(nilable_numeric_type.valid?(BasicObject.new)).to eq(false)
        expect(nilable_numeric_type.valid?(123.567)).to eq(true)
        expect(nilable_numeric_type.valid?(nil)).to eq(true)
        expect { nilable_numeric_type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_numeric_type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_numeric_type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_numeric_type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
        expect { nilable_numeric_type.validate!(123) }.not_to raise_error
        expect { nilable_numeric_type.validate!(123.567) }.not_to raise_error
        expect { nilable_numeric_type.validate!(nil) }.not_to raise_error
      end

      no_any_type = SmartCore::Types::Protocol::InstanceOf
      nillable_no_any_type = no_any_type.nilable

      aggregate_failures 'example of no-one-type-is-supported collection (non-nilable)' do
        expect(no_any_type.valid?('test')).to eq(false)
        expect(no_any_type.valid?(Object.new)).to eq(false)
        expect(no_any_type.valid?(BasicObject.new)).to eq(false)
        expect(no_any_type.valid?(nil)).to eq(false)
      end

      aggregate_failures 'example of no-one-type-is-supported collection (nilable)' do
        expect(nillable_no_any_type.valid?('test')).to eq(false)
        expect(nillable_no_any_type.valid?(Object.new)).to eq(false)
        expect(nillable_no_any_type.valid?(BasicObject.new)).to eq(false)
        expect(nillable_no_any_type.valid?(nil)).to eq(true)
      end
    end
    # rubocop:enable Layout/LineLength
  end
end
