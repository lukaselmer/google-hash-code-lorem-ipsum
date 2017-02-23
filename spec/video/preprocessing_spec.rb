require_relative '../spec_helper'
require_relative '../../video/parser'
require_relative '../../video/preprocessing'

RSpec.describe Preprocessing do
  context(:example_dataset) do
    let(:parser) do
      parser = Parser.new('video/datasets/example.in')
      parser.parse
      parser
    end

    it 'initializes with a parser' do
      expect(Preprocessing.new(parser).parser).to be_a(Parser)
    end

    describe 'preprocessing' do
      let(:preprocessing) { Preprocessing.new(parser) }

      it 'removes endpoints without a cache' do
        expect(preprocessing.parser.endpoints.length).to eq(2)
        preprocessing.preprocess_endpoints
        expect(preprocessing.parser.endpoints.length).to eq(1)
        expect(preprocessing.parser.endpoints[0].id).to eq(0)
      end

      it 'eliminates all empty caches' do
        empty_cache = Cache.new(33, 200, [], [])
        preprocessing.parser.caches << empty_cache
        expect(preprocessing.parser.caches.length).to eq(4)
        expect(preprocessing.parser.caches).to include(empty_cache)
        preprocessing.preprocess_caches
        expect(preprocessing.parser.caches.length).to eq(3)
        expect(preprocessing.parser.caches).not_to include(empty_cache)
      end

      it 'eliminates videos bigger than cache size' do
        to_big_video = preprocessing.parser.videos[4]
        expect(preprocessing.parser.videos.length).to eq(5)
        expect(preprocessing.parser.videos).to include(to_big_video)
        preprocessing.preprocess_videos
        expect(preprocessing.parser.videos.length).to eq(4)
        expect(preprocessing.parser.videos).not_to include(to_big_video)
      end

      it 'has a method preprocessing, which calls all preprocessing' do
        expect(preprocessing).to receive(:preprocess_endpoints)
        expect(preprocessing).to receive(:preprocess_caches)
        expect(preprocessing).to receive(:preprocess_videos)
        preprocessing.preprocess
      end
    end
  end
end

