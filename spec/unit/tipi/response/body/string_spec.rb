require 'spec_helper'

RSpec.describe Tipi::Response::Body::String do
  let(:instance) { described_class.new(value) }

  let(:value) { 'Hello' }

  describe '#each' do
    let(:collector) { [] }

    before(:each) do
      instance.each do |value|
        collector << value
      end
    end

    it 'yields once' do
      expect(collector).to contain_exactly('Hello')
    end
  end

  describe '#<<' do
    before(:each) do
      instance << ' '
      instance << 'world'
    end

    it 'append to string' do
      expect(instance.to_s).to eql('Hello world')
    end
  end

  describe '#size' do
    subject { instance.size }

    it 'should calculate bytesize of the string' do
      expect(subject).to eql(5)
    end
  end

  describe '#to_s' do
    subject { instance.to_s }

    it { expect(subject).to equal(value) }
  end
end
