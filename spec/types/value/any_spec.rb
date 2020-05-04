# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Any' do
  shared_examples 'type casting' do
    specify 'type-casting' do
    end
  end

  shared_exmaples 'type checking' do
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
    end
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
end
