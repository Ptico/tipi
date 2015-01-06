RSpec.describe Tipi::Status do
  describe '.[]' do
    subject { described_class[status] }

    context 'when status is an integer' do
      let(:status) { [200, 201, 302, 404].shuffle.first }

      it { expect(subject.code).to equal(status) }
    end

    context 'when status is a string' do
      let(:status) { '200' }

      it { expect(subject).to be(nil) }
    end
  end

  describe '.fetch' do
    subject { described_class.fetch(status) }

    context 'when status is an integer' do
      let(:status) { [100, 202, 301, 403].shuffle.first }

      it { expect(subject.code).to eql(status) }
    end

    context 'when status is a string' do
      let(:status) { %w(200 307 401 502).shuffle.first }

      it { expect(subject.code).to eql(status.to_i) }
    end

    context 'when status is not present' do
      let(:status) { 666 }

      it { expect { subject }.to raise_error(KeyError) }
    end

    context 'when status is not present but fallback given' do
      subject { described_class.fetch(status, default) }

      let(:status)  { 666 }
      let(:default) { described_class[200] }

      it { expect(subject).to eql(default) }
    end
  end

  describe '.registered?' do
    subject { described_class.registered?(status) }

    context 'when status is present' do
      context 'integer' do
        let(:status) { 200 }

        it { expect(subject).to be(true) }
      end

      context 'string' do
        let(:status) { '200' }

        it { expect(subject).to be(true) }
      end
    end

    context 'when status is not present' do
      let(:status) { 666 }

      it { expect(subject).to be(false) }
    end
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

  describe '#code' do
    it { expect(described_class[200].code).to equal(200) }
    it { expect(described_class[404].code).to equal(404) }
  end

  describe '#name' do
    it { expect(described_class[200].name).to eql('OK') }
    it { expect(described_class[301].name).to eql('Moved Permanently') }
  end

  describe '#type' do
    it { expect(described_class[100].type).to equal(:informational) }
    it { expect(described_class[201].type).to equal(:successful) }
    it { expect(described_class[301].type).to equal(:redirection) }
    it { expect(described_class[429].type).to equal(:client_error) }
    it { expect(described_class[504].type).to equal(:server_error) }
  end

  describe '#allows_body?' do
    let(:prohibited_statuses) { [100, 101, 102, 204, 205, 304] }

    context 'when entity body prohibited' do
      let(:statuses) do
        described_class.all.select { |s| prohibited_statuses.include?(s.code) }
      end

      it 'is false' do
        statuses.each do |status|
          expect(status.allows_body?).to be(false)
        end
      end
    end

    context 'when entity body allowed' do
      let(:statuses) do
        described_class.all.reject { |s| prohibited_statuses.include?(s.code) }
      end

      it 'is true' do
        statuses.each do |status|
          expect(status.allows_body?).to be(true)
        end
      end
    end
  end

  describe '#cacheable?' do
    let(:allowed_statuses) { Set[200, 203, 204, 206, 300, 301, 404, 405, 410, 414, 501] }

    context 'when caching allowed' do
      let(:statuses) do
        described_class.all.select { |s| allowed_statuses.include?(s.code)}
      end

      it 'is true' do
        statuses.each do |status|
          expect(status).to be_cacheable
        end
      end
    end

    context 'when caching prohibited' do
      let(:statuses) do
        described_class.all.reject { |s| allowed_statuses.include?(s.code)}
      end

      it 'is false' do
        statuses.each do |status|
          expect(status).to_not be_cacheable
        end
      end
    end
  end

  describe '#to_i' do
    it { expect(described_class[100].to_i).to equal(100) }
    it { expect(described_class[404].to_i).to equal(404) }
  end

  describe '#to_s' do
    it { expect(described_class[100].to_s).to eql('100') }
    it { expect(described_class[302].to_s).to eql('302') }
  end

end
