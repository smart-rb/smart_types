# frozen_string_literal: true

class GoodClass; end
class GoodClassAncestor < GoodClass; end
class BadClass; end

RSpec.describe 'SmartCore::Types::Protocol::Instance' do
  context 'non-nilable type' do
    let(:type) { SmartCore::Types::Protocol::Instance.of(GoodClass) }

    specify 'type-checking' do
      expect(type.valid?(GoodClass.new)).to eq(true)
      expect(type.valid?(GoodClassAncestor.new)).to eq(true)

      expect(type.valid?(BadClass.new)).to eq(false)
      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?('123')).to eq(false)
      expect(type.valid?(true)).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(18483.991238)).to eq(false)
      expect(type.valid?(99999999999)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(GoodClass.new) }.not_to raise_error
      expect { type.validate!(GoodClassAncestor.new) }.not_to raise_error

      expect { type.validate!(BadClass.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('123') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(true) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(18483.991238) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(99999999999) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'nilable type' do
    let(:type) { SmartCore::Types::Protocol::Instance.of(GoodClass).nilable }

    specify 'type-checking' do
      expect(type.valid?(GoodClass.new)).to eq(true)
      expect(type.valid?(GoodClassAncestor.new)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?(BadClass.new)).to eq(false)
      expect(type.valid?('123')).to eq(false)
      expect(type.valid?(true)).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(18483.991238)).to eq(false)
      expect(type.valid?(99999999999)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(GoodClass.new) }.not_to raise_error
      expect { type.validate!(GoodClassAncestor.new) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!(BadClass.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('123') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(true) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(18483.991238) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(99999999999) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
    end
  end
end
