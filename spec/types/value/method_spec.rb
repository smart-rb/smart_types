# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Method' do
  shared_examples 'type-casting' do
    specify 'type-casting' do
      expect { type.cast(nil) }.to raise_error(SmartCore::Types::TypeCastingUnsupportedError)
      expect { type.cast(Class) }.to raise_error(SmartCore::Types::TypeCastingUnsupportedError)
      expect { type.cast(Module) }.to raise_error(SmartCore::Types::TypeCastingUnsupportedError)
    end
  end

  shared_examples 'type-checking / type-validation (non-nilable)' do
    specify 'type-checking' do
      method_object = Object.new.method(:nil?)
      unbound_method_object = Object.new.method(:nil?).unbind

      expect(type.valid?(method_object)).to eq(true)
      expect(type.valid?(unbound_method_object)).to eq(false)
      expect(type.valid?(nil)).to eq(false)

      expect(type.valid?(-> {})).to eq(false)
      expect(type.valid?(proc {})).to eq(false)

      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(123.456)).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
    end

    specify 'type-valdation' do
      method_object = Object.new.method(:nil?)
      unbound_method_object = Object.new.method(:nil?).unbind

      expect { type.validate!(method_object) }.not_to raise_error
      expect { type.validate!(unbound_method_object) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)

      expect { type.validate!(-> {}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(proc {}) }.to raise_error(SmartCore::Types::TypeError)

      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123.456) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  shared_examples 'type-checking / type-validation (nilable)' do
    specify 'type-checking' do
      method_object = Object.new.method(:nil?)
      unbound_method_object = Object.new.method(:nil?).unbind

      expect(type.valid?(method_object)).to eq(true)
      expect(type.valid?(unbound_method_object)).to eq(false)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(-> {})).to eq(false)
      expect(type.valid?(proc {})).to eq(false)

      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
      expect(type.valid?(123)).to eq(false)
      expect(type.valid?(123.456)).to eq(false)
      expect(type.valid?('test')).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
    end

    specify 'type-valdation' do
      method_object = Object.new.method(:nil?)
      unbound_method_object = Object.new.method(:nil?).unbind

      expect { type.validate!(method_object) }.not_to raise_error
      expect { type.validate!(unbound_method_object) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(-> {}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(proc {}) }.to raise_error(SmartCore::Types::TypeError)

      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(123.456) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Value::Method }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (non-nilable)'
  end

  context 'runtime-based non-nilable type' do
    let(:type) { SmartCore::Types::Value::Method() }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (non-nilable)'
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Value::Method.nilable }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (nilable)'
  end

  context 'runtime-based nilable type' do
    let(:type) { SmartCore::Types::Value::Method().nilable }

    it_behaves_like 'type-casting'
    it_behaves_like 'type-checking / type-validation (nilable)'
  end
end
