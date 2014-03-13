require 'spec_helper'

describe ItemAsset do
  describe '#reprocess_asset' do
    let(:ia) { ItemAsset.new }
    let(:asset) { double }
    before do
      ItemAsset.any_instance.stub(:asset) { asset }
    end

    it 'should reload the asset and reprocess the attachment' do
      expect(asset).to receive(:reload) { asset }
      expect(asset).to receive(:attachment) { asset }
      expect(asset).to receive(:reprocess!)
      ia.reprocess_asset
    end
  end
end
