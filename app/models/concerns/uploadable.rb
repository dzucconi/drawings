module Uploadable
  extend ActiveSupport::Concern

  BUCKET = ENV['AWS_S3_BUCKET'].freeze

  def filename
    raise Exception 'filename must be defined'
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

  def remove_uploaded_object
    client.delete_object(
      bucket: BUCKET,
      key: key
    )
  end

  def extension
    File.extname(filename)
  end

  def key
    "#{self.class.to_s.pluralize.parameterize}/#{id}/#{File.basename(filename, extension).parameterize}#{extension}"
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
end
