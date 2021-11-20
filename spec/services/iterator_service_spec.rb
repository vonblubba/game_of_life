# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IteratorService do
  context 'provided a valid generation file' do
    let(:input_file_path) { file_fixture('test_generation_00.txt') }
    let(:expected_output) { file_fixture('test_generation_expected_00.txt').read }
    let(:iterator_service) { described_class.new(file_path: input_file_path) }

    it 'creates next generation and returns required output' do
      result = iterator_service.run

      expect(Generation.count).to eq 2
      expect(result).to eq expected_output
    end
  end
end
