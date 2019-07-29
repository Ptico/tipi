require 'spec_helper'

RSpec.describe Tipi::Header do
  describe '.register' do
    subject { described_class.register(header_name, klass) }
  end

  xdescribe '.registered?' do

  end

  xdescribe '.[]' do
    subject { described_class[header_name] }

    context 'when Properly-Cased' do

    end

    context 'when down-cased' do

    end

    context 'when RACK_CASED (which sucks a lot)' do

    end
  end

  xdescribe '.fetch' do

  end

  describe '#call' do
    subject { described_class.new(header_name).call(header_value) }

    let(:header_name) { 'Connection' }
    let(:header_value) { 'keep-alive' }

    it 'should assign value' do
      expect(subject.value).to eql(header_value)
      expect(subject.http_value).to eql(header_value)
    end
  end

  describe '#set' do
    subject { described_class.new(header_name).set(header_value) }

    let(:header_name)  { 'Upgrade-Insecure-Requests' }
    let(:header_value) { 1 }

    it 'should assign typed value' do
      expect(subject.value).to equal(1)
      expect(subject.http_value).to eql('1')
    end
  end

  describe '#add' do

  end


  describe '#name' do
    subject { described_class.new(header_name).name }

    let(:header_name) { 'X-Header' }

    it 'should return header name' do
      expect(subject).to eql(header_name)
    end
  end

  describe '#value' do
    let(:instance) { described_class.new('X-Header') }

    context 'when set by #set' do
      subject { instance.set(header_value).value }

      context 'when string' do
        let(:header_value) { 'foo' }

        it 'returns string' do
          expect(subject).to eql(header_value)
        end
      end

      context 'when typed' do
        let(:header_value) { 5 }

        it 'returns typed value' do
          expect(subject).to eql(header_value)
        end
      end
    end

    context 'when set by #call' do
      subject { instance.call(header_value).value }

      context 'when string' do
        let(:header_value) { 'foo' }

        it 'returns string' do
          expect(subject).to eql(header_value)
        end
      end

      context 'when typed' do
        let(:header_value) { 5 }

        it 'returns string' do
          expect(subject).to eql(header_value.to_s)
        end
      end
    end
  end

  describe '#http_value' do
    let(:instance) { described_class.new('X-Header') }

    context 'when set by #set' do
      subject { instance.set(header_value).http_value }

      context 'when string' do
        let(:header_value) { 'foo' }

        it 'returns string' do
          expect(subject).to eql(header_value)
        end
      end

      context 'when typed' do
        let(:header_value) { 5 }

        it 'returns string' do
          expect(subject).to eql(header_value.to_s)
        end
      end
    end

    context 'when set by #call' do
      subject { instance.call(header_value).value }

      context 'when string' do
        let(:header_value) { 'foo' }

        it 'returns string' do
          expect(subject).to eql(header_value)
        end
      end

      context 'when typed' do
        let(:header_value) { 5 }

        it 'returns string' do
          expect(subject).to eql(header_value.to_s)
        end
      end
    end
  end

  describe '#to_s' do
    subject { described_class.new(header_name).(header_value).to_s }

    let(:header_name)  { 'X-Content' }
    let(:header_value) { 'foxtrot,uniform,charlie,kilo' }

    it 'returns HTTP-header string' do
      expect(subject).to eql('X-Content: foxtrot,uniform,charlie,kilo')
    end
  end
end
