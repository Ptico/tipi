require 'spec_helper'

RSpec.describe Tipi::Response::Body::Array do
  let(:instance) { described_class.new(value) }

  let(:value) { ['Hello', ' ', 'world'] }

  describe '#each' do
    let(:collector) { [] }

    context 'when block given' do
      before(:each) do
        instance.each do |value|
          collector << value
        end
      end

      it 'yield each element' do
        expect(collector).to contain_exactly('Hello', ' ', 'world')
      end
    end

    context 'when without block' do
      before(:each) do
        instance.each.with_index do |val, i|
          collector << val
          collector << i
        end

        it 'returns enum for each' do
          expect(collector).to contain_exactly('Hello', 1, ' ', 2, 'world', 3)
        end
      end
    end
  end

  describe '#<<' do
    before(:each) do
      instance << '!'
    end

    it 'pushes an element to the end' do
      expect(instance.to_s).to eql('Hello world!')
    end
  end

  describe '#size' do
    subject { instance.size }

    it 'should calculate bytesize of the string' do
      expect(subject).to eql(11)
    end
  end


  describe '#to_s' do
    subject { instance.to_s }

    it { expect(subject).to eql('Hello world') }
  end
end
