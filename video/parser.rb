Endpoint = Struct.new(:datacenter_latency, :caches)
Cache = Struct.new(:index, :cache_latency)
RequestDescription = Struct.new(:video, :endpoint, :num_requests)

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
    @videos = @lines.shift.strip.split(' ').map(&:to_i)
  end

  def parse_endpoints
    @endpoints = []
    num_endpoints.times do
      parse_endpoint
    end
  end

  def parse_endpoint
    datacenter_latency, num_connected_caches = @lines.shift.strip.split(' ').map(&:to_i)
    endpoint = Endpoint.new(datacenter_latency, [])
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

      @request_descriptions << nil
    end
  end
end
