require 'time'

class Export
  attr_reader :caches

  def initialize(caches, name = nil)
    @caches = caches
    @caches.keep_if { |cache| !cache.videos.empty? }
    @name = name
  end

  def output
    output = []
    output << [caches.length]
    @caches.each do |cache|
      output << [cache.id, *cache.videos.map(&:id)]
    end
    output
  end

  def generate_file
    Dir.mkdir('out') unless Dir.exists?('out')
    File.write("out/output_#{@name}.out", generate_export_data)
    # File.write("out/output_#{Time.now.iso8601}.out", generate_export_data)
  end

  def generate_export_data
    output.map { |line| line.join ' ' }.join("\n")
  end
end
