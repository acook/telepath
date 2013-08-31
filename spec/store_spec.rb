require_relative 'spec_helper'

describe Telepath::Store do
  it 'exists' do
    expect(Telepath::Store).to be
  end

  let(:default_file){ '.telepath.db' }
  let(:default_path){ File.expand_path '~' }
  let(:default_location){ "#{default_path}/#{default_file}" }

  describe '.file' do
    subject(:file){ described_class.file }

    it 'matches defaults' do
      expect(file.to_s).to eq default_file
    end
  end

  describe '.path' do
    subject(:path){ described_class.path }

    it 'defaults to home directory' do
      expect(path.to_s).to eq default_path
    end
  end

  describe '.location' do
    subject(:path){ described_class.location }

    it 'defaults to a combination of the path and file' do
      expect(path.to_s).to eq default_location
    end
  end

  describe '.create' do
    it 'relays the new data store to new' do
      expect(described_class).to receive(:new).with anything
      described_class.create
    end

    it 'assigns the store object' do
      expect(described_class.create.send(:store)).to be
    end
  end
end
