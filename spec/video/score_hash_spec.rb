require_relative '../spec_helper'
require_relative '../../video/score_hash'
require_relative '../../video/parser'

RSpec.describe ScoreHash do

  describe '#score_for_assignment' do
    let(:endpoint_0) { {id: 0, datacenter_latency: 1000, request_descriptions: [request_description_0]} }
    let(:cache_connection_0_1) { {cache_id: 1, cache_latency: 300, endpoint: endpoint_0} }
    let(:cache_1) { {id: 1, cache_size: 100, cache_connections: [cache_connection_0_1]} }
    let(:caches) { [cache_1] }

    let(:request_description_0) { {video_id: 1, endpoint_id: 0, num_requests: 1000} }
    let(:request_description_other) { {video_id: 1, endpoint_id: 0, num_requests: 2000} }
    let(:request_descriptions) { [request_description_0, request_description_other] }

    let(:parameters){ {request_descriptions: request_descriptions, caches: caches} }
    let(:parser) {instance_double(Parser, parameters)}

    subject { described_class.new(parser) }

    it 'calculates the correct result for the assignment 1, 1' do
      expect(subject.score_for_assignment(1, 1)).to eq 233_333
    end
  end
end
