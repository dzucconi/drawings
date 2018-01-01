# == Schema Information
#
# Table name: drawings
#
#  id                 :integer          not null, primary key
#  title              :string
#  width              :integer
#  height             :integer
#  units              :string
#  image_content_type :string
#  image_filename     :string
#  image_filesize     :integer
#  image_width        :integer
#  image_height       :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Drawing < ApplicationRecord
  include Uploadable

  validates :title, presence: true

  def to_s
    title || image_filename || 'untitled'
  end
end
