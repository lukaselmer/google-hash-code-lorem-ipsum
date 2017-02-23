require_relative 'parser'
require_relative 'random_optimize'
require_relative 'export'
require_relative 'preprocessing'

['kittens', 'me_at_the_zoo', 'trending_today', 'videos_worth_spreading'].each do |dataset_name|
  data = Parser.new("video/datasets/#{dataset_name}.in")
  data.parse

  Preprocessing.new(data).preprocess
  RandomOptimizer.new(data).run

  Export.new(data.caches, dataset_name).generate_file
end
