class ResizedImage
  attr_reader :url, :width, :height, :factor, :ratio

  ENDPOINT = ENV['IMAGE_RESIZING_PROXY_ENDPOINT'].freeze
  CANCER_SECRET_KEY = ENV['CANCER_SECRET_KEY'].freeze
  KEY_TEMPLATE = '<OP>/<WIDTH>x<HEIGHT>/<QUALITY>/<URL>'.freeze
  REQUEST_TEMPLATE = '<ENDPOINT>/<TOKEN>/<KEY>'.freeze
  DEFAULT_OP = 'resize'.freeze
  DEFAULT_SCALE = 1.0
  DEFAULT_QUALITY = 95

  def initialize(url:, scale: DEFAULT_SCALE, original_width:, original_height:, width: nil, height: nil)
    @url = url

    @factor = [
      (width.to_f / original_width.to_f if width.present?),
      (height.to_f / original_height.to_f if height.present?),
    ].compact.min

    @width = ([(original_width * factor), original_width].min * scale).to_i
    @height = ([(original_height * factor), original_height].min * scale).to_i

    @ratio = (@height.to_f / @width.to_f) * 100.0
  end

  def size(factor = 1)
    keyed = key(factor)
    REQUEST_TEMPLATE
      .gsub('<ENDPOINT>', ENDPOINT)
      .gsub('<TOKEN>', tokenize(keyed))
      .gsub('<KEY>', keyed)
  end

  def key(factor = 1)
    KEY_TEMPLATE
      .gsub('<OP>', DEFAULT_OP)
      .gsub('<WIDTH>', (width * factor).to_s)
      .gsub('<HEIGHT>', (height * factor).to_s)
      .gsub('<QUALITY>', DEFAULT_QUALITY.to_s)
      .gsub('<URL>', encode_uri_component(url))
  end

  def encode_uri_component(url)
    URI.escape(url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  def tokenize(data)
    OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha1'),
      CANCER_SECRET_KEY,
      data
    )
  end
end
