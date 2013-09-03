require_relative 'spec_helper'

describe 'Telepath Executable' do
  let(:exe){ run "./bin/tel #{command} #{args.join ' '}" }
  let(:status){ exe.status }
  let(:stdout){ exe.stdout.strip }

  let(:handler){ Telepath::Handler.new double(Clamp::Command) }
  let(:value){ '12' }
  let(:next_value){ 'Boo yah!' }

  # override these in context
  let(:command){ '' }
  let(:args){ [] }

  before do
    pre_test_setup
  end

  after do
    post_test_teardown
  end

  it 'runs' do
    expect(status).to be_success
  end

  context 'invalid arguments' do
    let(:args){ ['invalid_argument'] }
    specify { expect(status).to_not be_success }
  end

  describe '+ add' do
    let(:command){ :+ }

    context 'without value' do
      specify { expect(status).to_not be_success }
    end

    context 'with value' do
      let(:args){ ['12'] }

      specify { expect(status).to be_success }

      it 'adds the value to the stack' do
        expect(stdout).to eq("Added 12 to stack!")
      end

      it 'should have no error output' do
        expect(exe.stderr).to eq ''
      end
    end

    context 'with multiple values' do
      let(:args){ ['12', 'foo/bar'] }

      it 'adds the value to the stack' do
        expect(stdout).to eq("Added [12, foo/bar] to stack!")
      end
    end

    context 'redirected input' do
      xit 'reads and stores stdin' do
        # how to test?
      end
    end
  end

  describe '? lookup' do
    let(:command){ '?' }

    before do
      handler.add value
    end

    context 'without parameters' do
      context 'with values in telepath' do
        specify { expect(status).to be_success }
        specify { expect(stdout).to eq value }
      end
    end

    context 'with parameters' do
      let(:args){ ['1'] }

      specify { expect(status).to be_success }
      specify { expect(stdout).to eq value }
    end
  end

  describe '@ index' do
    let(:command){ '@' }

    before do
      handler.add value
      handler.add next_value
    end

    context 'with single index' do
      let(:args){ [1] }

      it 'returns only that item' do
        expect(stdout).to eq value
      end
    end

    context 'with indicies' do
      let(:args){ [0, 1] }

      it 'returns each index on a new line' do
        expect(stdout).to eq %Q{Boo yah!\n12}
      end
    end
  end

  describe '$ last' do
    let(:command){ '$' }

    before do
      handler.add value
      handler.add next_value
    end

    context 'without parameters' do
      context 'with values in telepath' do
        specify { expect(status).to be_success }
        specify { expect(stdout).to eq next_value }
      end
    end

    context 'with parameters' do
      let(:args){ ['2'] }

      specify { expect(status).to be_success }

      it 'returns each most recent item on a new line' do
        expect(stdout).to eq %Q{12\nBoo yah!}
      end
    end
  end

  describe 'list' do
    let(:command){ 'list' }

    before do
      handler.add value
      handler.add next_value
      handler.add 'something else', 'another container'
    end

    context 'without parameters' do
      it 'lists known containers, most recent first' do
        expect(stdout).to eq "another container\nstack"
      end
    end

    context 'with contaienr specified' do
      let(:args){ ['"another container"'] }

      it 'lists the contents of the specified container' do
        expect(stdout).to eq 'something else'
      end
    end

    context 'with nonexistant container' do
      let(:args){ ['"totally does not exist"'] }
      let(:container_list_exe){ run './bin/tel list' }
      let(:container_list){ container_list_exe.stdout.strip }

      it 'does not create listed containers' do
        expect(stdout).to eq ''
        expect(container_list).to eq "another container\nstack"
      end
    end
  end

end
