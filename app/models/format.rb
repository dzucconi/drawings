# == Schema Information
#
# Table name: formats
#
#  id         :integer          not null, primary key
#  width      :float
#  height     :float
#  unit       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Format < ApplicationRecord
  has_many :drawings

  validates_presence_of :width
  validates_presence_of :height
  validates_presence_of :unit

  def to_s
    name.present? ? "#{name} (#{dimensions})" : dimensions
  end

  def dimensions
    "#{width} × #{height} #{unit}"
  end
end
