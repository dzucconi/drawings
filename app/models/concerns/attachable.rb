module Attachable
  extend ActiveSupport::Concern

  included do
    validates :attachment_content_type, presence: true
    validates :attachment_filename, presence: true
    validates :attachment_filesize, presence: true

    before_destroy :remove_uploaded_object
  end

  def filename
    attachment_filename
  end
end
