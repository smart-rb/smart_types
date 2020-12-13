# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Protocol::InstanceOf' do
  specify 'smoke (dirty logic check) (this spec will be rewritten)' do
    string_type = SmartCore::Types::Protocol::InstanceOf(::String, ::Symbol)
    nilable_string_type = string_type.nilable

    expect(string_type.valid?(:test)).to eq(true)
    expect(string_type.valid?('test')).to eq(true)
    expect(string_type.valid?(123)).to eq(false)
    expect(string_type.valid?(nil)).to eq(false)
    expect { string_type.validate!(:test) }.not_to raise_error
    expect { string_type.validate!('test') }.not_to raise_error
    expect { string_type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
    expect { string_type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)

    expect(nilable_string_type.valid?(:test)).to eq(true)
    expect(nilable_string_type.valid?('test')).to eq(true)
    expect(nilable_string_type.valid?(123)).to eq(false)
    expect(nilable_string_type.valid?(nil)).to eq(true)
    expect { nilable_string_type.validate!(:test) }.not_to raise_error
    expect { nilable_string_type.validate!('test') }.not_to raise_error
    expect { nilable_string_type.validate!(123) }.to raise_error(SmartCore::Types::TypeError)
    expect { nilable_string_type.validate!(nil) }.not_to raise_error

    numeric_type = SmartCore::Types::Protocol::InstanceOf(::Integer, ::Float)
    nilable_numeric_type = numeric_type.nilable

    expect(numeric_type.valid?(:test)).to eq(false)
    expect(numeric_type.valid?('test')).to eq(false)
    expect(numeric_type.valid?(123)).to eq(true)
    expect(numeric_type.valid?(123.567)).to eq(true)
    expect(numeric_type.valid?(nil)).to eq(false)
    expect { numeric_type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
    expect { numeric_type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
    expect { numeric_type.validate!(123) }.not_to raise_error
    expect { numeric_type.validate!(123.567) }.not_to raise_error
    expect { numeric_type.validate!(nil) }.to raise_error(SmartCore::Types::TypeError)

    expect(nilable_numeric_type.valid?(:test)).to eq(false)
    expect(nilable_numeric_type.valid?('test')).to eq(false)
    expect(nilable_numeric_type.valid?(123.567)).to eq(true)
    expect(nilable_numeric_type.valid?(nil)).to eq(true)
    expect { nilable_numeric_type.validate!(:test) }.to raise_error(SmartCore::Types::TypeError)
    expect { nilable_numeric_type.validate!('test') }.to raise_error(SmartCore::Types::TypeError)
    expect { nilable_numeric_type.validate!(123) }.not_to raise_error
    expect { nilable_numeric_type.validate!(123.567) }.not_to raise_error
    expect { nilable_numeric_type.validate!(nil) }.not_to raise_error
  end
end
