class Parser
  attr_reader :videos, :caches, :endpoints
  attr_reader :num_videos, :num_endpoints, :num_request_descriptions, :num_caches, :cache_size

  def initialize(path)
    @lines = File.readlines(path)
  end

  def parse
    parse_first_line
  end

  def parse_first_line
    line = @lines.shift.strip.split(' ').map(&:to_i)
    @num_videos, @num_endpoints, @num_request_descriptions, @num_caches, @cache_size = line
  end

  # def parse_header(lines)
  #   x = lines.shift.split(' ')
  #   @min_number_of_ingredient = x[2].to_i
  #   @max_cells = x[3].to_i
  # end
  #
  # def parse_grid(lines)
  #   @grid = lines.map do |row|
  #     row.strip.split('').map(&:downcase).map(&:to_sym)
  #   end
  # end
end
