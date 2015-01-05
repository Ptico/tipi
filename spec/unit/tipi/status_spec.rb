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

  describe '#allows_entity_body?' do
    let(:prohibited_statuses) { [100, 101, 102, 204, 205, 304] }

    context 'when entity body prohibited' do
      let(:statuses) do
        Tipi::Status.all.select { |s| prohibited_statuses.include?(s.code) }
      end

      it 'is false' do
        statuses.each do |status|
          expect(status.allows_entity_body?).to be(false)
        end
      end
    end

    context 'when entity body allowed' do
      let(:statuses) do
        Tipi::Status.all.reject { |s| prohibited_statuses.include?(s.code) }
      end

      it 'is true' do
        expect(status.allows_entity_body?).to be(true)
      end
    end
  end

  describe '#allows_caching?' do
    let(:allowed_statuses) { Set[200, 203, 204, 206, 300, 301, 404, 405, 410, 414, 501] }

    context 'when caching allowed' do
      let(:statuses) do
        Tipi::Status.all.select { |s| allowed_statuses.include?(s.code)}
      end

      it 'is true' do
        statuses.each do |status|
          expect(status.allows_caching?).to be(true)
        end
      end
    end

    context 'when caching prohibited' do
      let(:statuses) do
        Tipi::Status.all.reject { |s| allowed_statuses.include?(s.code)}
      end

      it 'is false' do
        statuses.each do |status|
          expect(status.allows_caching?).to be(false)
        end
      end
    end
  end

end
