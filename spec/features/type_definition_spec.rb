# frozen_string_literal: true

RSpec.describe 'Type Definition' do
  specify do
    SmartCore::Types::Value.define_type(:String) do |type|
      type.define_caster do |value|
        value.to_s
      end

      type.define_checker do |value|
        value.is_a?(String)
      end
    end
  end
end
