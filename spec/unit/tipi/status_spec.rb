RSpec.describe Tipi::Status do
  describe '.[]' do

  end

  describe '.valid?' do

  end

  describe '.type' do
    subject { described_class.type(status) }

    context 'informational' do
      let(:status) { rand(100..199) }

      it { expect(subject).to equal(:informational) }
    end

    context 'successful' do
      let(:status) { rand(200..299) }

      it { expect(subject).to equal(:successful) }
    end

    context 'redirection' do
      let(:status) { rand(300..399) }

      it { expect(subject).to equal(:redirection) }
    end

    context 'client_error' do
      let(:status) { rand(400..499) }

      it { expect(subject).to equal(:client_error) }
    end

    context 'server_error' do
      let(:status) { rand(500..599) }

      it { expect(subject).to equal(:server_error) }
    end
  end

  describe 'statuses without entity body' do

  end

  describe 'non-cacheable statuses' do

  end

end
