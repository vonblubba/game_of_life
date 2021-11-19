# frozen_string_literal: true

FactoryBot.define do
  factory :generation do
    world { 'test_world' }
    iteration { 0 }
    grid { [[1, 1], [0, 0]] }
  end
end
