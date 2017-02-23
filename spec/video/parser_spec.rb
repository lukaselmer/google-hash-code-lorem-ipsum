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
    expect(parser.videos.length).to eq(5)
    expect(parser.videos[0].id).to eq(0)
    expect(parser.videos[1].id).to eq(1)
    expect(parser.videos[2].id).to eq(2)
    expect(parser.videos[3].id).to eq(3)
    expect(parser.videos[4].id).to eq(4)
    expect(parser.videos[0].size).to eq(50)
    expect(parser.videos[1].size).to eq(50)
    expect(parser.videos[2].size).to eq(80)
    expect(parser.videos[3].size).to eq(30)
    expect(parser.videos[4].size).to eq(110)
  end

  it 'parses the first endpoint latency' do
    expect(parser.endpoints[0].id).to eq(0)
    expect(parser.endpoints[1].id).to eq(1)
    expect(parser.endpoints[0].datacenter_latency).to eq(1000)
  end

  it 'parses the first endpoint caches' do
    expect(parser.endpoints[0].cache_connections.length).to eq(3)
    expect(parser.endpoints[0].cache_connections[0].cache_id).to eq(0)
    expect(parser.endpoints[0].cache_connections[0].cache_latency).to eq(100)
    expect(parser.endpoints[0].cache_connections[1].cache_id).to eq(2)
    expect(parser.endpoints[0].cache_connections[1].cache_latency).to eq(200)
    expect(parser.endpoints[0].cache_connections[2].cache_id).to eq(1)
    expect(parser.endpoints[0].cache_connections[2].cache_latency).to eq(300)
  end

  it 'parses all endpoints incl caches' do
    expect(parser.endpoints[1].cache_connections.length).to eq(0)
  end

  it 'parses the request_descriptions' do
    expect(parser.request_descriptions.length).to eq(4)
    expect(parser.request_descriptions[0].video_id).to eq(3)
    expect(parser.request_descriptions[0].endpoint_id).to eq(0)
    expect(parser.request_descriptions[0].num_requests).to eq(1500)
  end

  it 'makes the correct request description references' do
    expect(parser.request_descriptions[0].video).to eq(parser.videos[3])
    expect(parser.request_descriptions[0].endpoint).to eq(parser.endpoints[0])
  end

  it 'makes the correct endpoint references' do
    expect(parser.endpoints[0].request_descriptions.length).to eq(3)
    expect(parser.endpoints[0].request_descriptions[0]).to eq(parser.request_descriptions[0])
    expect(parser.endpoints[0].request_descriptions[1]).to eq(parser.request_descriptions[2])
    expect(parser.endpoints[0].request_descriptions[2]).to eq(parser.request_descriptions[3])
  end

  it 'initializes the correct caches' do
    expect(parser.caches.length).to eq(parser.num_caches)
    expect(parser.caches[1].id).to eq(1)
    expect(parser.caches[1].cache_size).to eq(parser.cache_size)
  end

  it 'references the correct caches to the cache connections' do
    expect(parser.endpoints[0].cache_connections[1].cache).to eq(parser.caches[2])
  end
end
