module Imageable
  extend ActiveSupport::Concern

  included do
    validates :image_content_type, presence: true
    validates :image_filename, presence: true
    validates :image_filesize, presence: true
    validates :image_width, presence: true
    validates :image_height, presence: true

    before_destroy :remove_uploaded_object
  end

  def filename
    image_filename
  end

  def resize_source_url
    ResizedImage.new(
      url: qualified_url,
      original_width: image_width,
      original_height: image_height,
      width: 2500,
      height: 2500,
      scale: ResizedImage::DEFAULT_SCALE
    ).size(1)
  end

  def resized(width: nil, height: nil, scale: ResizedImage::DEFAULT_SCALE)
    ResizedImage.new(
      url: resize_source_url,
      original_width: image_width,
      original_height: image_height,
      width: width,
      height: height,
      scale: scale
    )
  end
end
