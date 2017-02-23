Video = Struct.new(:id, :size)
Endpoint = Struct.new(:id, :datacenter_latency, :caches)
Cache = Struct.new(:id, :cache_latency)
RequestDescription = Struct.new(:video_id, :endpoint_id, :num_requests, :video, :endpoint)

class Parser
  attr_reader :videos, :endpoints, :request_descriptions
  attr_reader :num_videos, :num_endpoints, :num_request_descriptions, :num_caches, :cache_size

  def initialize(path)
    @lines = File.readlines(path)
  end

  def parse
    parse_first_line
    parse_videos
    parse_endpoints
    parse_request_descriptions
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
    endpoint = Endpoint.new(endpoint_id, datacenter_latency, [])
    num_connected_caches.times do
      line = @lines.shift.strip.split(' ').map(&:to_i)
      endpoint.caches << Cache.new(*line)
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
end
