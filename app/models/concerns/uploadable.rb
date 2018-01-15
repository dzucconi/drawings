module Uploadable
  extend ActiveSupport::Concern

  BUCKET = ENV['AWS_S3_BUCKET'].freeze

  included do
    validates :image_content_type, presence: true
    validates :image_filename, presence: true
    validates :image_filesize, presence: true
    validates :image_width, presence: true
    validates :image_height, presence: true

    before_destroy :remove_image
  end

  def client
    @client ||= Aws::S3::Client.new
  end

  def put(upload_io)
    client.put_object(
      body: upload_io.read,
      bucket: BUCKET,
      key: key,
      acl: 'public-read'
    )
  end

  def remove_image
    client.delete_object(
      bucket: BUCKET,
      key: key
    )
  end

  def extension
    File.extname(image_filename)
  end

  def key
    "#{id}/#{File.basename(image_filename, extension).parameterize}#{extension}"
  end

  def presigned_url
    Aws::S3::Resource.new
                     .bucket(BUCKET)
                     .object(key)
                     .presigned_url(:put, acl: 'public-read')
  end

  def qualified_url
    "https://#{BUCKET}.s3.amazonaws.com/#{key}"
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
