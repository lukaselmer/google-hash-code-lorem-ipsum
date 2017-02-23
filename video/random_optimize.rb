require_relative 'score_hash'

class RandomOptimizer
  def initialize(data)
    @data = data
    @score_hash = ScoreHash.new(@data)
  end

  def run
    @data.caches.each do |cache|
      @current_cache = cache
      10.times do
        @caching_failed = 0
        while @caching_failed < 100
          request_description = cache.cache_connections.sample.endpoint.request_descriptions.sample
          video = request_description.video
          if @current_cache.cache_size >= video.size && !@current_cache.videos.include?(video)
            fill_video(video)
          else
            @caching_failed += 1
          end
        end

        if rand < 0.1
          videos = @current_cache.videos.sample(3)
          z = videos.map do |video|
            score = @score_hash.score_for_assignment(video, @current_cache)
            [score, video]
          end.sort_by { |x| x[0] }
          @current_cache.videos = @current_cache.videos.select { |v| v != z[1] }
        end
      end

      @caching_failed = 0
      while @caching_failed < 100
        request_description = cache.cache_connections.sample.endpoint.request_descriptions.sample
        video = request_description.video
        if @current_cache.cache_size >= video.size && !@current_cache.videos.include?(video)
          fill_video(video)
        else
          @caching_failed += 1
        end
      end
    end
  end

  def fill_video(video)
    @current_cache.videos << video
    @current_cache.cache_size -= video.size
    @caching_failed = 0
  end
end
