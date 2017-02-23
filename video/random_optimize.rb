class RandomOptimizer
  def initialize(data)
    @data = data
  end

  def run
    @data.caches.each do |cache|
      @current_cache = cache
      @caching_failed = 0
      while @caching_failed < 10000
        video = cache.cache_connections.sample.endpoint.request_descriptions.sample.video
        if @current_cache.cache_size >= video.size && !@current_cache.videos.include?(video)
          @current_cache.videos << video
          @current_cache.cache_size -= video.size
          @caching_failed = 0
        else
          @caching_failed += 1
        end
      end
    end
  end
end
