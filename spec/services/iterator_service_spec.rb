# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IteratorService do
  context 'provided a valid generation file' do
    let(:input_file_path) { file_fixture('test_generation_00.txt') }
    let(:expected_output) { file_fixture('test_generation_expected_00.txt').read }
    let(:current_generation) { GenerationCreationService.new(file_path: input_file_path).run }
    let(:iterator_service) { described_class.new(current_gen_id: current_generation.id) }

    it 'creates next generation and returns required output' do
      next_gen = iterator_service.run[:next_gen]

      expect(Generation.count).to eq 2
      expect(next_gen.decorate.complete_output).to eq expected_output
    end
  end
end
