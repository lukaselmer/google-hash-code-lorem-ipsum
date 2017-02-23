require_relative '../spec_helper'
require_relative '../../video/score_hash'
require_relative '../../video/parser'

RSpec.describe ScoreHash do

  describe '#score_for_assignment' do
    let(:endpoint_0) { Endpoint.new(0, 1000, nil, [request_description_0]) }
    let(:cache_connection_0_1) { CacheConnection.new(1, 300, nil, endpoint_0) }
    let(:cache_1) { Cache.new(1, 100, nil, [cache_connection_0_1]) }
    let(:caches) { [cache_1] }

    let(:request_description_0) { RequestDescription.new(1, 0, 1000) }
    let(:request_description_other) { RequestDescription.new(1, 0, 2000) }
    let(:request_descriptions) { [request_description_0, request_description_other] }

    let(:parameters){ {request_descriptions: request_descriptions, caches: caches} }
    let(:parser) {instance_double(Parser, parameters)}

    subject { described_class.new(parser) }

    it 'calculates the correct result for the assignment 1, 1' do
      expect(subject.score_for_assignment(1, 1)).to eq 233_333
    end
  end
end
