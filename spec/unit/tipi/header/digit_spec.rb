require 'spec_helper'

RSpec.describe Tipi::Header::Digit do
  describe '#call' do
    subject { described_class.new(header_name).call(header_value) }

    let(:header_name) { 'Content-Length' }
    let(:header_value) { '1448' }

    it 'should assign value' do
      expect(subject.value).to      eql(header_value.to_i)
      expect(subject.http_value).to eql(header_value)
    end
  end

  describe '#set' do
    subject { described_class.new(header_name).set(header_value) }

    let(:header_name)  { 'Content-Length' }
    let(:header_value) { rand(9999) }

    it 'should assign typed value' do
      expect(subject.value).to      equal(header_value)
      expect(subject.http_value).to eql(header_value.to_s)
    end
  end

end
