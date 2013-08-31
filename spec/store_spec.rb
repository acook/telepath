require_relative 'spec_helper'

describe Telepath::Store do
  it 'exists' do
    expect(Telepath::Store).to be
  end

  let(:default_file){ '.telepath.db' }
  let(:default_path){ File.expand_path '~' }
  let(:default_location){ "#{default_path}/#{default_file}" }

  context 'with default location' do
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

      context 'invalid path' do
        before do
          ENV[described_class::PATH_VAR] = '/this/path/doesnt/exist/hopefully'
        end

        after do
          ENV[described_class::PATH_VAR] = nil
        end

        specify { expect{path}.to raise_exception }
      end
    end
  end

  context 'with test location' do
    def test_path
      Telepath.root.join 'tmp'
    end

    def test_file
      test_path.join described_class.file
    end

    before :all do
      ENV[described_class::PATH_VAR] = test_path.to_s
      test_file.delete if test_file.exist?
    end

    after :all do
      ENV[described_class::PATH_VAR] = nil
      test_file.delete if test_file.exist?
    end

    describe '.create' do
      before do
        Moneta.stub(:new) { 'test object' }
      end

      it 'relays the new data store to new' do
        expect(described_class).to receive(:new).with anything
        described_class.create
      end

      it 'assigns the store object' do
        store = described_class.create
        expect(store.send(:store)).to eq 'test object'
      end
    end
  end
end
