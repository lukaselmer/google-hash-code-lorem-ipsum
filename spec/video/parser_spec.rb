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

  it 'parses the videos' do
    expect(parser.videos).to eq([50, 50, 80, 30, 110])
  end

  it 'parses the first endpoint latency' do
    expect(parser.endpoints[0].datacenter_latency).to eq(1000)
  end

  it 'parses the first endpoint caches' do
    expect(parser.endpoints[0].caches.length).to eq(3)
    expect(parser.endpoints[0].caches[0].index).to eq(0)
    expect(parser.endpoints[0].caches[0].cache_latency).to eq(100)
    expect(parser.endpoints[0].caches[1].index).to eq(2)
    expect(parser.endpoints[0].caches[1].cache_latency).to eq(200)
    expect(parser.endpoints[0].caches[2].index).to eq(1)
    expect(parser.endpoints[0].caches[2].cache_latency).to eq(300)
  end

  it 'parses all endpoints incl caches' do
    expect(parser.endpoints[1].caches.length).to eq(0)
  end

  it 'parses the request_descriptions' do
    expect(parser.request_descriptions.length).to eq(4)
  end

end
