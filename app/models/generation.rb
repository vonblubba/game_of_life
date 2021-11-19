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
class Generation < ApplicationRecord
  serialize :grid

  validates :grid, presence: true
  validates :iteration, presence: true
  validates :world, presence: true
  validates :iteration, uniqueness: { scope: :world }
end
