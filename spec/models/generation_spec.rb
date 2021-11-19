# frozen_string_literal: true

# == Schema Information
#
# Table name: generations
#
#  id         :integer          not null, primary key
#  grid       :text             not null
#  iteration  :integer          not null
#  world      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_generations_on_iteration            (iteration)
#  index_generations_on_world                (world)
#  index_generations_on_world_and_iteration  (world,iteration) UNIQUE
#
require 'rails_helper'

RSpec.describe Generation, type: :model do
  context 'validations' do
    let(:generation) { build(:generation) }

    context 'without grid' do
      it 'is invalid' do
        generation.grid = nil

        expect(generation).to be_invalid
      end
    end

    context 'without a world' do
      it 'is invalid' do
        generation.world = nil

        expect(generation).to be_invalid
      end
    end

    context 'without an iteration' do
      it 'is invalid' do
        generation.iteration = nil

        expect(generation).to be_invalid
      end
    end

    context 'with duplicated world/iteration' do
      let!(:generation1) { create(:generation) }
      let!(:generation2) { build(:generation) }

      it 'is invalid' do
        expect(generation2).to be_invalid
      end
    end
  end

  context 'methods' do
    let(:generation1) do
      column1 = [0, 0, 0, 0]
      column2 = [0, 0, 0, 0]
      column3 = [0, 0, 0, 0]
      column4 = [0, 0, 1, 0]
      column5 = [0, 1, 1, 0]
      column6 = [0, 0, 0, 0]
      column7 = [0, 0, 0, 0]
      column8 = [0, 0, 0, 0]

      create(:generation, world: 'test_world1', iteration: 0, grid: [column1, column2, column3, column4, column5, column6, column7, column8])
    end

    let(:expected_generation2) do
      column1 = [0, 0, 0, 0]
      column2 = [0, 0, 0, 0]
      column3 = [0, 0, 0, 0]
      column4 = [0, 1, 1, 0]
      column5 = [0, 1, 1, 0]
      column6 = [0, 0, 0, 0]
      column7 = [0, 0, 0, 0]
      column8 = [0, 0, 0, 0]

      create(:generation, world: 'test_world1', iteration: 1, grid: [column1, column2, column3, column4, column5, column6, column7, column8])
    end

    context '#next_gen_state' do
      context 'provided out of bounds indexes' do
        it 'raises error' do
          expect { generation1.next_gen_state(x_coordinate: 0, y_coordinate: 100) }.to raise_error(RuntimeError)
          expect { generation1.next_gen_state(x_coordinate: 100, y_coordinate: 0) }.to raise_error(RuntimeError)
        end
      end

      it 'evaluates correctly next gen state' do
        0.upto 7 do |x|
          0.upto 3 do |y|
            expect(generation1.next_gen_state(x_coordinate: x, y_coordinate: y)).to eq expected_generation2.grid[x][y]
          end
        end
      end
    end

    context '#neighbours' do
      context 'provided out of bounds indexes' do
        it 'raises error' do
          expect { generation1.neighbours(x_coordinate: 0, y_coordinate: 100) }.to raise_error(RuntimeError)
          expect { generation1.neighbours(x_coordinate: 100, y_coordinate: 0) }.to raise_error(RuntimeError)
        end
      end

      it 'returns neighbors array' do
        expect(generation1.neighbours(x_coordinate: 0, y_coordinate: 0)).to eq [0, 0, 0]
        expect(generation1.neighbours(x_coordinate: 4, y_coordinate: 1)).to eq [0, 0, 1, 0, 1, 0, 0, 0]
      end
    end
  end
end
