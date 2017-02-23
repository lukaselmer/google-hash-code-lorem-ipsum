require_relative '../spec_helper'
require_relative '../../video/parser'

RSpec.describe Parser do
  let(:parser) do
    parser = Parser.new('video/datasets/example.in')
    parser.parse
    parser
  end

  it 'parses the first line' do
    expect(parser.num_videos).to eq(5)
    expect(parser.num_endpoints).to eq(2)
    expect(parser.num_request_descriptions).to eq(4)
    expect(parser.num_caches).to eq(3)
    expect(parser.cache_size).to eq(100)
  end
end
