# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Value::Integer' do
  shared_examples 'type casting' do
    specify 'type-casting' do
    end
  end

  context 'non-nilable type' do
    include_examples 'type casting'

    let(:type) { SmartCore::Types::Value::Integer }

    specify 'type-checking' do
    end

    specify 'type-validation' do
    end
  end

  context 'nilable type' do
    include_examples 'type casting'

    let(:type) { SmartCore::Types::Value::Integer.nilable }

    specify 'type-checking' do
    end

    specify 'type-validation' do
    end
  end
end
