module Uploadable
  extend ActiveSupport::Concern

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
      bucket: bucket,
      key: key,
      acl: 'public-read'
    )
  end

  def remove_image
    client.delete_object(
      bucket: bucket,
      key: key
    )
  end

  def bucket
    ENV['AWS_S3_BUCKET']
  end

  def extension
    File.extname(image_filename)
  end

  def key
    "#{id}/#{File.basename(image_filename, extension).parameterize}#{extension}"
  end

  def signed
    Aws::S3::Resource.new
                     .bucket(bucket)
                     .object(key)
                     .presigned_url(:put, acl: 'public-read')
  end

  def qualified
    "https://#{bucket}.s3.amazonaws.com/#{key}"
  end

  def resized(width: nil, height: nil, scale: ResizedImage::DEFAULT_SCALE)
    ResizedImage.new(
      url: self.qualified,
      original_width: self.image_width,
      original_height: self.image_height,
      width: width,
      height: height,
      scale: scale
    )
  end
end
