require 'spec_helper'

RSpec.describe Tipi::Response::Body do
  describe '.call' do
    subject { described_class.(value) }

    context 'when string' do
      let(:value) { 'Hello world' }

      it { expect(subject).to an_instance_of(Tipi::Response::Body::String) }
    end

    context 'when array' do
      let(:value) { ['Hello', 'world'] }

      it { expect(subject).to an_instance_of(Tipi::Response::Body::Array) }
    end

    context 'when respond to #read' do
      let(:value) { StringIO.new }

      it { expect(subject).to an_instance_of(Tipi::Response::Body::IO) }
    end

    context 'when other' do
      let(:value) { rand(100) }

      it { expect { subject }.to raise_error(ArgumentError, 'body must be a String, Array or IO') }
    end
  end

end
