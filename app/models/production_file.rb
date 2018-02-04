# == Schema Information
#
# Table name: production_files
#
#  id                      :integer          not null, primary key
#  name                    :string
#  attachment_filesize     :integer
#  attachment_content_type :string
#  attachment_filename     :string
#  drawing_id              :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class ProductionFile < ApplicationRecord
  include Uploadable
  include Attachable

  belongs_to :drawing

  def to_s
    !name.blank? && "#{name} (#{attachment_filename})" || attachment_filename
  end
end
