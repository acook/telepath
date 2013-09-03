require_relative 'spec_helper'

describe Telepath::Storage do
  subject(:storage){ described_class.new }
  let(:default_file){ '.telepath.db' }
  let(:default_path){ File.expand_path '~' }
  let(:default_location){ "#{default_path}/#{default_file}" }

  it 'exists' do
    expect(described_class).to be
  end

  context 'with default location' do
    describe '#file' do
      subject(:file){ storage.file }

      it 'matches defaults' do
        expect(file.to_s).to eq default_file
      end
    end

    describe '#path' do
      subject(:path){ storage.path }

      it 'defaults to home directory' do
        expect(path.to_s).to eq default_path
      end
    end

    describe '#location' do
      subject(:path){ storage.location }

      it 'defaults to a combination of the path and file' do
        expect(path.to_s).to eq default_location
      end

      context 'invalid path' do
        before do
          ENV[path_env_var] = '/this/path/doesnt/exist/hopefully'
        end

        after do
          ENV[path_env_var] = nil
        end

        specify { expect{path}.to raise_exception }
      end
    end
  end

  context 'with test location' do

    before :all do
      pre_test_setup
    end

    after :all do
      post_test_teardown
    end

    describe '.new' do
      before do
        Moneta.stub(:new) { 'test object' }
      end

      it 'creates a store object using Moneta' do
        expect(storage.store).to eq 'test object'
      end
    end
  end
end
