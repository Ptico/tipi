require 'spec_helper'

RSpec.describe Tipi::Header::DateTime do
  describe '#call' do
    subject { described_class.new(header_name).call(header_value) }

    let(:header_name) { 'Expires' }

    context 'when date is valid RFC2616 date' do
      let(:header_value) { 'Sat, 19 Jan 2038 03:14:08 GMT' }

      it 'should assign value' do
        expect(subject.value).to eql(::DateTime.new(2038, 1, 19, 3, 14, 8, 0))
        expect(subject.http_value).to eql(header_value)
      end
    end

    context 'when date is invalid' do
      let(:header_value) { 'Sat, 19 Jan 2038 03:14:08 UTC' }

      it 'should raise an error' do
        expect { subject.value }.to raise_error(ArgumentError, 'invalid date')
      end
    end
  end

  describe '#set' do
    subject { described_class.new(header_name).set(header_value) }

    let(:header_name) { 'Date' }

    context 'when datetime' do
      let(:header_value) { ::DateTime.new(1969, 7, 21, 2, 56, 15, 0) }

      it 'should assign value' do
        expect(subject.http_value).to eql('Mon, 21 Jul 1969 02:56:15 GMT')
      end
    end

    context 'when time' do
      let(:header_value) { ::Time.new(2012, 8, 6, 5, 17) }

      it 'should assign value' do
        expect(subject.http_value).to eql('Mon, 06 Aug 2012 02:17:00 GMT')
      end
    end

    context 'when date' do
      let(:header_value) { ::Date.new(1990, 8, 24) }

      it 'should assign value' do
        expect(subject.http_value).to eql('Fri, 24 Aug 1990 00:00:00 GMT')
      end
    end

    context 'when string' do
      let(:header_value) { 'Sat, 10 May 1986 00:55:00 EEST' }

      it 'should assign value' do
        expect(subject.http_value).to eql('Fri, 09 May 1986 21:55:00 GMT')
      end
    end

    context 'when integer' do
      let(:header_value) { 730512000 } # Wed 24 Feb 1993

      it 'should assign value' do
        expect(subject.http_value).to eql('Wed, 24 Feb 1993 00:00:00 GMT')
      end
    end
  end
end
