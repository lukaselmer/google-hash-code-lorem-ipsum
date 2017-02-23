require_relative 'parser'

parser = Parser.new('pizza/datasets/small.in')
parser.parse
p parser.grid
p parser.min_number_of_ingredient
p parser.max_cells
