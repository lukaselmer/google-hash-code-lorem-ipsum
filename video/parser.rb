Video = Struct.new(:id, :size)
Endpoint = Struct.new(:id, :datacenter_latency, :cache_connections, :request_descriptions)
Cache = Struct.new(:id, :cache_size, :videos)
CacheConnection = Struct.new(:cache_id, :cache_latency, :cache)
RequestDescription = Struct.new(:video_id, :endpoint_id, :num_requests, :video, :endpoint)

class Parser
  attr_reader :videos, :endpoints, :request_descriptions, :caches
  attr_reader :num_videos, :num_endpoints, :num_request_descriptions, :num_caches, :cache_size

  def initialize(path)
    @lines = File.readlines(path)
  end

  def parse
    parse_first_line
    parse_videos
    parse_endpoints
    parse_request_descriptions
    reference_endpoints
    initialize_caches
    reference_caches_to_cache_connections
  end

  def parse_first_line
    line = @lines.shift.strip.split(' ').map(&:to_i)
    @num_videos, @num_endpoints, @num_request_descriptions, @num_caches, @cache_size = line
  end

  def parse_videos
    @videos = @lines.shift.strip.split(' ').map(&:to_i).each_with_index.map do |size, id|
      Video.new(id, size)
    end
  end

  def parse_endpoints
    @endpoints = []
    num_endpoints.times do |i|
      parse_endpoint(i)
    end
  end

  def parse_endpoint(endpoint_id)
    datacenter_latency, num_connected_caches = @lines.shift.strip.split(' ').map(&:to_i)
    endpoint = Endpoint.new(endpoint_id, datacenter_latency, [], [])
    num_connected_caches.times do
      line = @lines.shift.strip.split(' ').map(&:to_i)
      endpoint.cache_connections << CacheConnection.new(*line)
    end
    @endpoints << endpoint
  end

  def parse_request_descriptions
    @request_descriptions = []
    @num_request_descriptions.times do
      line = @lines.shift.strip.split(' ').map(&:to_i)
      request_description = RequestDescription.new(*line)
      request_description.video = videos[request_description.video_id]
      request_description.endpoint = endpoints[request_description.endpoint_id]
      @request_descriptions << request_description
    end
  end

  def reference_endpoints
    @request_descriptions.each do |request_description|
      request_description.endpoint.request_descriptions << request_description
    end
  end

  def initialize_caches
    @caches = []
    num_caches.times { |id| @caches << Cache.new(id, cache_size, []) }
  end

  def reference_caches_to_cache_connections
    endpoints.each do |endpoint|
      endpoint.cache_connections.each do |cache_connection|
        cache_connection.cache = caches[cache_connection.cache_id]
      end
    end
  end
end
