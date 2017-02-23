require_relative '../spec_helper'
require_relative '../../video/parser'
require_relative '../../video/export'

RSpec.describe Export do
  let(:video_1) { Video.new(1, 5) }
  let(:video_2) { Video.new(2, 5) }
  let(:video_3) { Video.new(3, 5) }
  let(:video_4) { Video.new(4, 5) }
  let(:video_5) { Video.new(5, 5) }

  let(:caches) do
    [
      Cache.new(0, 200, [video_1]),
      Cache.new(1, 200, [video_2, video_3]),
      Cache.new(2, 200, [video_4]),
      Cache.new(3, 200, [])
    ]
  end

  describe 'output' do
    let(:export) { Export.new(caches, 'spec') }

    it 'the correct output line length' do
      expect(export.output.length).to eq(4)
    end

    it 'returns only caches which are used' do
      expect(export.output[0]).to eq([3])
    end

    it 'returns the first cache and lists its videos' do
      expect(export.output[1]).to eq([0, 1])
      expect(export.output[2]).to eq([1, 2, 3])
      expect(export.output[3]).to eq([2, 4])
    end
  end

  describe 'export file' do
    let(:export) { Export.new(caches, 'spec') }

    it 'generates the right export file' do
      expect(export.generate_export_data).to eq(
        "3\n"\
        "0 1\n"\
        "1 2 3\n"\
        '2 4'
      )
    end
  end

end
