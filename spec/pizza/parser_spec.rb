require_relative '../spec_helper'
require_relative '../../pizza/parser'

RSpec.describe Parser do
  let(:parser) do
    parser = Parser.new('pizza/datasets/small.in')
    parser.parse
    parser
  end

  it 'works' do
    expect(parser.min_number_of_ingredient).to eq(1)
    expect(parser.max_cells).to eq(5)
  end

  it 'parses the grid' do
    expect(parser.grid).to eq(
      [
        [:t, :m, :m, :m, :t, :t, :t],
        [:m, :m, :m, :m, :t, :m, :m],
        [:t, :t, :m, :t, :t, :m, :t],
        [:t, :m, :m, :t, :m, :m, :m],
        [:t, :t, :t, :t, :t, :t, :m],
        [:t, :t, :t, :t, :t, :t, :m]
      ]
    )
  end
end
