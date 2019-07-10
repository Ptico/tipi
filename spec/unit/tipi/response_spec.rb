require 'spec_helper'

RSpec.describe Tipi::Response do
  describe '#status=' do
    context 'when Tipi::Status' do
      let(:value) { Tipi::Status[302] }
    end

    context 'when string' do
      let(:value) { '400' }
    end

    context 'when integer' do
      let(:value) { 201 }
    end

    context 'when does not respond to #to_i' do
      let(:value) { Hash.new }
    end
  end

  describe '#body=' do
    context 'when string' do
      let(:value) { 'Hello world' }
    end

    context 'when enumerable' do
      let(:value) {  }
    end

    context 'when instance of Response::Body' do

    end

    context 'when respond to #read' do

    end

    context 'when respond to #call' do

    end
  end

  describe '#headers' do

  end

end
