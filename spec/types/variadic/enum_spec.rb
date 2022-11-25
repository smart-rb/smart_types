# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Variadic::Enum' do
  describe 'runtime-based behavior' do
    specify 'requires enum values (runtime attributes)' do
      expect do
        SmartCore::Types::Variadic::Enum()
      end.to raise_error(SmartCore::Types::IncorrectRuntimeAttributesError)
    end
  end

  describe 'logic' do
    let(:type) { SmartCore::Types::Variadic::Enum(10, '20', false) }

    specify 'type-checking' do
      expect(type.valid?(10)).to eq(true)
      expect(type.valid?('20')).to eq(true)
      expect(type.valid?(false)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?('123')).to eq(false)
      expect(type.valid?(true)).to eq(false)
      expect(type.valid?(:test)).to eq(false)
      expect(type.valid?(18_483.991238)).to eq(false)
      expect(type.valid?(99_999_999_999)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?([])).to eq(false)
      expect(type.valid?(Object.new)).to eq(false)
      expect(type.valid?(BasicObject.new)).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(10) }.not_to raise_error
      expect { type.validate!('20') }.not_to raise_error
      expect { type.validate!(false) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!('123') }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(true) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(18_483.991238) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(99_999_999_999) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
    end

    context 'nilable type' do
      let(:type) { SmartCore::Types::Variadic::Enum(10, '20', false).nilable }

      specify 'type-checking' do
        expect(type.valid?(10)).to eq(true)
        expect(type.valid?('20')).to eq(true)
        expect(type.valid?(false)).to eq(true)
        expect(type.valid?(nil)).to eq(true)

        expect(type.valid?('123')).to eq(false)
        expect(type.valid?(true)).to eq(false)
        expect(type.valid?(:test)).to eq(false)
        expect(type.valid?(18_483.991238)).to eq(false)
        expect(type.valid?(99_999_999_999)).to eq(false)
        expect(type.valid?({})).to eq(false)
        expect(type.valid?([])).to eq(false)
        expect(type.valid?(Object.new)).to eq(false)
        expect(type.valid?(BasicObject.new)).to eq(false)
      end

      specify 'type-validation' do
        expect { type.validate!(10) }.not_to raise_error
        expect { type.validate!('20') }.not_to raise_error
        expect { type.validate!(false) }.not_to raise_error
        expect { type.validate!(nil) }.not_to raise_error

        expect { type.validate!('123') }.to raise_error(SmartCore::Types::TypeError)
        expect { type.validate!(true) }.to raise_error(SmartCore::Types::TypeError)
        expect { type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
        expect { type.validate!(18_483.991238) }.to raise_error(SmartCore::Types::TypeError)
        expect { type.validate!(99_999_999_999) }.to raise_error(SmartCore::Types::TypeError)
        expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
        expect { type.validate!([]) }.to raise_error(SmartCore::Types::TypeError)
        expect { type.validate!(Object.new) }.to raise_error(SmartCore::Types::TypeError)
        expect { type.validate!(BasicObject.new) }.to raise_error(SmartCore::Types::TypeError)
      end
    end
  end
end
