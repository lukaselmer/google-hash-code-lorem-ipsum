class Parser
  def initialize(path)
    @path = path
  end

  def parse
    lines = File.readlines(@path)
    lines.shift
    lines.map do |row|
      row.strip.split('').map(&:downcase).map(&:to_sym)
    end
  end
end
