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
end
