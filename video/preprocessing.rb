class Preprocessing
  attr_reader :parser

  def initialize(parser)
    @parser = parser
  end

  def preprocess_endpoints
    @parser.endpoints.delete_if { |endpoint| endpoint.cache_connections.empty? }
  end

  def preprocess_caches
    @parser.caches.delete_if { |cache| cache.cache_connections.empty? }
  end

  def preprocess_videos
    @parser.videos.delete_if { |video| video.size > @parser.cache_size }
  end

  def preprocess
    preprocess_endpoints
    preprocess_caches
    preprocess_videos
  end
end
