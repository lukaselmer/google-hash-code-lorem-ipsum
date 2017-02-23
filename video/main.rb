require_relative 'parser'
require_relative 'random_optimize'
require_relative 'export'

data = Parser.new('video/datasets/kittens.in')
data.parse

optimizer = RandomOptimizer.new(data)
optimizer.run
p optimizer.solution

Export.new(data.caches).generate_file
