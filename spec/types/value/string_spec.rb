# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::String' do
  shared_examples 'type casting' do
    specify 'type-casting' do
      expect(type.cast(:test)).to eq('test')
      expect(type.cast('test')).to eq('test')
      expect(type.cast(nil)).to eq('')
      expect(type.cast({})).to eq('{}')
      expect(type.cast({ a: 1, 'b' => :test })).to eq('{:a=>1, "b"=>:test}')
      expect(type.cast([])).to eq('[]')
      expect(type.cast([1, 'test', :test])).to eq('[1, "test", :test]')

      castable = Class.new { def to_s; 'test'; end; }.new
      expect(type.cast(castable)).to eq('test')

      non_castable_1 = Class.new { undef_method :to_s; }.new
      non_castable_2 = Class.new { def to_s; 2; end }.new
      expect { type.cast(non_castable_1) }.to raise_error(SmartCore::Types::TypeCastingError)
      expect { type.cast(non_castable_2) }.to raise_error(SmartCore::Types::TypeCastingError)
    end
  end

  shared_examples 'type-checking / type-validation (non-nilable)' do
    specify 'type-checking' do
      expect(type.valid?('test')).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(:test)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.valid?('test') }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  shared_examples 'type-checking / type-validation (nilable)' do
    specify 'type-checking' do
      expect(type.valid?('test')).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(:test)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.valid?('test') }.not_to raise_error
      expect { type.valid?(nil) }.not_to raise_error

      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::String }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::String() }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (non-nilable)'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::String.nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::String().nilable }

    include_examples 'type casting'
    include_examples 'type-checking / type-validation (nilable)'
  end

  specify 'has no support for runtime attributes' do
    expect { SmartCore::Types::Value::String('test') }.to raise_error(
      SmartCore::Types::RuntimeAttriburtesUnsupportedError
    )
  end
end
