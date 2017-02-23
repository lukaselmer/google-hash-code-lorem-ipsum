class ScoreHash
  attr_reader :request_descriptions

  def initialize(parser)
    @caches = parser.caches
    @requests = parser.request_descriptions
    @request_descriptions = Hash parser.request_descriptions.map {|request| ["#{request.video_id} #{request.endpoint_id}", request]}.to_h
  end

  def score_for_assignment(video, cache)
    video_id = video.id

    score = 0
    connections = cache.cache_connections
    connections.each do |connection|
      endpoint = connection.endpoint
      request = request_by_endpoint_and_video(endpoint, video_id)
      if request
        data_center_latency = endpoint.datacenter_latency
        cache_latency = connection.cache_latency
        num_requests = request.num_requests

        score += (data_center_latency - cache_latency) * num_requests * 1000
      end
    end

    score / total_request_time
  end

  private

  def cache_by_id(cache_id)
    @caches.find { |cache| cache[:id] == cache_id }
  end

  def request_by_endpoint_and_video(endpoint, video_id)
    request_descriptions["#{video_id} #{endpoint.id}"]
    #endpoint.request_descriptions.find { |request| request.video_id == video_id }
  end

  def total_request_time
    @total_request_time ||= @requests.inject(0) { |sum, request| sum + request.num_requests }
  end
end
