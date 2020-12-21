# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Set' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect(type.cast(123)).to eq(Set.new([123]))
      expect(type.cast([:test, '123'])).to eq(Set.new([:test, '123']))
      expect(type.cast(123.456)).to eq(Set.new([123.456]))
      expect(type.cast({ a: 1 })).to eq(Set.new({ a: 1 }))
      expect(type.cast(nil)).to eq(Set.new)
      expect(type.cast([])).to eq(Set.new)

      as_array_1 = Class.new { def to_a; [123]; end }.new
      as_array_2 = Class.new { def to_ary; ['456']; end }.new
      non_array_1 = Class.new { def to_a; :test; end }.new
      non_array_2 = Class.new { def to_ary; 'test'; end }.new
      object = Object.new

      expect(type.cast(as_array_1)).to eq(Set.new([123]))
      expect(type.cast(as_array_2)).to eq(Set.new(['456']))
      expect(type.cast(non_array_1)).to eq(Set.new([non_array_1]))
      expect(type.cast(non_array_2)).to eq(Set.new([non_array_2]))
      expect(type.cast(object)).to eq(Set.new([object]))

      basic_object = BasicObject.new
      expect { type.cast(basic_object) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  shared_examples 'type-checking / type-validation (non-nilable)' do
    specify 'type-checking' do
      expect(type.valid?(Set.new)).to eq(true)
      expect(type.valid?(Set.new([123, 45.6, 'test', :test, Object.new]))).to eq(true)

      expect(type.valid?([])).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
      expect(type.valid?(123.456)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?('test')).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(Set.new) }.not_to raise_error
      expect { type.validate!(Set.new([123, 45.6, 'test', :test, Object.new])) }.not_to raise_error

      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123.456) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  shared_examples 'type-checking / type-validation (nilable)' do
    specify 'type-checking' do
      expect(type.valid?(Set.new)).to eq(true)
      expect(type.valid?(Set.new([123, 45.6, 'test', :test, Object.new]))).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?([])).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
      expect(type.valid?(123.456)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?('test')).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(Set.new) }.not_to raise_error
      expect { type.validate!(Set.new([123, 45.6, 'test', :test, Object.new])) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123.456) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Set }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::Set() }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Set.nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::Set().nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::Set(Set.new([1, 2, 3])) }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
