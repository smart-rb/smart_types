# frozen_string_literal: true

RSpec.describe 'OBJECT BEHAVIOR: object cloning/copying/duplication' do
  specify '(smoke test [TODO]: rewrite) copying should not fail' do
    expect { SmartCore::Types::Value::Any.dup }.not_to raise_error
    expect { SmartCore::Types::Value::Any.clone }.not_to raise_error
  end
end
