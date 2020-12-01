# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Struct::StrictHash' do
  let(:correct_value) { Hash[int: 10, str: '20', bool: false] }

  context 'non-nilable type' do
    let(:type) do
      SmartCore::Types::Struct::StrictHash[
        int: SmartCore::Types::Value::Integer,
        str: SmartCore::Types::Value::String,
        bool: SmartCore::Types::Value::Boolean
      ]
    end

    specify 'type-checking' do
      expect(type.valid?(correct_value)).to eq(true)

      expect(type.valid?(nil)).to eq(false)
      expect(type.valid?({})).to eq(false)
      expect(type.valid?(correct_value.merge(int: nil))).to eq(false)
      expect(type.valid?(correct_value.merge(int: :test))).to eq(false)
      expect(type.valid?(correct_value.merge(str: []))).to eq(false)
      expect(type.valid?(correct_value.merge(bool: {}))).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(correct_value) }.not_to raise_error

      expect { type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(correct_value.merge(int: nil)) }
        .to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(correct_value.merge(int: :test)) }
        .to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(correct_value.merge(str: [])) }
        .to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(correct_value.merge(bool: {})) }
        .to raise_error(SmartCore::Types::TypeError)
    end
  end

  context 'nilable type' do
    let(:type) do
      SmartCore::Types::Struct::StrictHash[
        int: SmartCore::Types::Value::Integer,
        str: SmartCore::Types::Value::String,
        bool: SmartCore::Types::Value::Boolean
      ].nilable
    end

    specify 'type-checking' do
      expect(type.valid?(correct_value)).to eq(true)
      expect(type.valid?(nil)).to eq(true)

      expect(type.valid?({})).to eq(false)
      expect(type.valid?(correct_value.merge(int: nil))).to eq(false)
      expect(type.valid?(correct_value.merge(int: :test))).to eq(false)
      expect(type.valid?(correct_value.merge(str: []))).to eq(false)
      expect(type.valid?(correct_value.merge(bool: {}))).to eq(false)
    end

    specify 'type-validation' do
      expect { type.validate!(correct_value) }.not_to raise_error
      expect { type.validate!(nil) }.not_to raise_error

      expect { type.validate!({}) }.to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(correct_value.merge(int: nil)) }
        .to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(correct_value.merge(int: :test)) }
        .to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(correct_value.merge(str: [])) }
        .to raise_error(SmartCore::Types::TypeError)
      expect { type.validate!(correct_value.merge(bool: {})) }
        .to raise_error(SmartCore::Types::TypeError)
    end
  end
end
