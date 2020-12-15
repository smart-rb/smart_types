# frozen_string_literal: true

RSpec.describe 'SmartCore::Types::Variadic::Tuple' do
  xdescribe 'runtime-based behavior' do
    xspecify 'fails on non-class objects (should work only with classes)'
    xspecify 'requires tuple signature (runtime attributes)'
  end

  xdescribe 'logic' do
    xspecify 'type-checking'
    xspecify 'type-casting'
    xspecify 'type-validation'
  end
end
