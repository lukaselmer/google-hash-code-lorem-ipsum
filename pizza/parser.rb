class Parser
  attr_reader :grid, :min_number_of_ingredient, :max_cells

  def initialize(path)
    @path = path
  end

  def parse
    lines = File.readlines(@path)
    parse_header(lines)
    parse_grid(lines)
  end

  def parse_header(lines)
    x = lines.shift.split(' ')
    @min_number_of_ingredient = x[2]
    @max_cells = x[3]
  end

  def parse_grid(lines)
    @grid = lines.map do |row|
      row.strip.split('').map(&:downcase).map(&:to_sym)
    end
  end
end
