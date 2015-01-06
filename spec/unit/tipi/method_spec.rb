require 'spec_helper'

RSpec.describe Tipi::Method do
  VERBS = %w[GET POST PUT PATCH DELETE HEAD TRACE OPTIONS]

  describe '.all' do
    subject { described_class.all }

    VERBS.each do |verb|
      it "should contain #{verb}" do
        expect(subject.map(&:verb)).to include(verb)
      end
    end
  end


  describe '.[]' do
    context 'when verb is upcased string' do
      it 'should return method instance' do
        VERBS.each do |verb|
          expect(described_class[verb]).to be_kind_of(described_class)
        end
      end
    end

    context 'when verb is not upcased string' do
      it 'should return nil' do
        VERBS.each do |verb|
          expect(described_class[verb.downcase]).to be(nil)
        end
      end
    end
  end

  describe '.fetch' do
    subject { described_class.fetch(verb) }

    context 'when verb is upcased string' do
      VERBS.each do |meth|
        context "and method is #{meth}" do
          let(:verb) { meth }

          it { expect(subject).to be_kind_of(described_class) }
        end
      end
    end

    context 'when verb is downcased string' do
      VERBS.each do |meth|
        context "and method is #{meth}" do
          let(:verb) { meth.downcase }

          it { expect(subject).to be_kind_of(described_class) }
        end
      end
    end

    context 'when verb is a symbol' do
      VERBS.each do |meth|
        context "and method is #{meth}" do
          let(:verb) { meth.downcase.to_sym }

          it { expect(subject).to be_kind_of(described_class) }
        end
      end
    end

    context 'when verb is not present' do
      let(:verb) { 'SHIT' }

      it { expect { subject }.to raise_error(KeyError) }
    end

    context 'when verb is not present but fallback given' do
      subject { described_class.fetch(verb, default) }

      let(:verb)    { 'SHIT' }
      let(:default) { Tipi::Method['GET'] }

      it { expect(subject).to equal(default) }
    end
  end

  describe '.valid?' do
    subject { described_class.valid?(verb) }

    context 'when verb is present' do
      context 'upcased string' do
        let(:verb) { 'GET' }

        it { expect(subject).to be(true) }
      end

      context 'string' do
        let(:verb) { 'get' }

        it { expect(subject).to be(true) }
      end

      context 'symbol' do
        let(:verb) { :get }

        it { expect(subject).to be(true) }
      end
    end

    context 'when verb not present' do
      let(:verb) { :shit }

      it { expect(subject).to be(false) }
    end
  end

  describe 'GET' do
    subject { described_class::GET }

    it { expect(subject).to be_get }

    it { expect(subject).to_not be_post }
    it { expect(subject).to_not be_put }
    it { expect(subject).to_not be_patch }
    it { expect(subject).to_not be_delete }
    it { expect(subject).to_not be_head }
    it { expect(subject).to_not be_trace }
    it { expect(subject).to_not be_options }
    it { expect(subject).to_not be_link }
    it { expect(subject).to_not be_unlink }

    it { expect(subject).to be_safe       }
    it { expect(subject).to be_idempotent }
    it { expect(subject).to be_cacheable  }

    it { expect(subject.allows_body?).to be(true) }

    it { expect(subject.to_sym).to equal(:get) }
    it { expect(subject.to_s).to   eql('GET')  }
    it { expect(subject.verb).to   eql('GET')  }
  end

  describe 'POST' do
    subject { described_class::POST }

    it { expect(subject).to be_post }

    it { expect(subject).to_not be_get }
    it { expect(subject).to_not be_put }
    it { expect(subject).to_not be_patch }
    it { expect(subject).to_not be_delete }
    it { expect(subject).to_not be_head }
    it { expect(subject).to_not be_trace }
    it { expect(subject).to_not be_options }
    it { expect(subject).to_not be_link }
    it { expect(subject).to_not be_unlink }

    it { expect(subject).to_not be_safe       }
    it { expect(subject).to_not be_idempotent }
    it { expect(subject).to_not be_cacheable  }

    it { expect(subject.allows_body?).to be(true) }

    it { expect(subject.to_sym).to equal(:post) }
    it { expect(subject.to_s).to   eql('POST')  }
    it { expect(subject.verb).to   eql('POST')  }
  end

  describe 'PUT' do
    subject { described_class::PUT }

    it { expect(subject).to be_put }

    it { expect(subject).to_not be_get }
    it { expect(subject).to_not be_post }
    it { expect(subject).to_not be_patch }
    it { expect(subject).to_not be_delete }
    it { expect(subject).to_not be_head }
    it { expect(subject).to_not be_trace }
    it { expect(subject).to_not be_options }
    it { expect(subject).to_not be_link }
    it { expect(subject).to_not be_unlink }

    it { expect(subject).to_not be_safe       }
    it { expect(subject).to     be_idempotent }
    it { expect(subject).to_not be_cacheable  }

    it { expect(subject.allows_body?).to be(true) }

    it { expect(subject.to_sym).to equal(:put) }
    it { expect(subject.to_s).to   eql('PUT')  }
    it { expect(subject.verb).to   eql('PUT')  }
  end

  describe 'PATCH' do
    subject { described_class::PATCH }

    it { expect(subject).to be_patch }

    it { expect(subject).to_not be_get }
    it { expect(subject).to_not be_post }
    it { expect(subject).to_not be_put }
    it { expect(subject).to_not be_delete }
    it { expect(subject).to_not be_head }
    it { expect(subject).to_not be_trace }
    it { expect(subject).to_not be_options }
    it { expect(subject).to_not be_link }
    it { expect(subject).to_not be_unlink }

    it { expect(subject).to_not be_safe       }
    it { expect(subject).to_not be_idempotent }
    it { expect(subject).to_not be_cacheable  }

    it { expect(subject.allows_body?).to be(true) }

    it { expect(subject.to_sym).to equal(:patch) }
    it { expect(subject.to_s).to   eql('PATCH')  }
    it { expect(subject.verb).to   eql('PATCH')  }
  end

  describe 'DELETE' do
    subject { described_class::DELETE }

    it { expect(subject).to be_delete }

    it { expect(subject).to_not be_get }
    it { expect(subject).to_not be_post }
    it { expect(subject).to_not be_put }
    it { expect(subject).to_not be_patch }
    it { expect(subject).to_not be_head }
    it { expect(subject).to_not be_trace }
    it { expect(subject).to_not be_options }
    it { expect(subject).to_not be_link }
    it { expect(subject).to_not be_unlink }

    it { expect(subject).to_not be_safe       }
    it { expect(subject).to     be_idempotent }
    it { expect(subject).to_not be_cacheable  }

    it { expect(subject.allows_body?).to be(true) }

    it { expect(subject.to_sym).to equal(:delete) }
    it { expect(subject.to_s).to   eql('DELETE')  }
    it { expect(subject.verb).to   eql('DELETE')  }
  end

  describe 'HEAD' do
    subject { described_class::HEAD }

    it { expect(subject).to be_head }

    it { expect(subject).to_not be_get }
    it { expect(subject).to_not be_post }
    it { expect(subject).to_not be_put }
    it { expect(subject).to_not be_patch }
    it { expect(subject).to_not be_delete }
    it { expect(subject).to_not be_trace }
    it { expect(subject).to_not be_options }
    it { expect(subject).to_not be_link }
    it { expect(subject).to_not be_unlink }

    it { expect(subject).to be_safe       }
    it { expect(subject).to be_idempotent }
    it { expect(subject).to be_cacheable  }

    it { expect(subject.allows_body?).to be(false) }

    it { expect(subject.to_sym).to equal(:head) }
    it { expect(subject.to_s).to   eql('HEAD')  }
    it { expect(subject.verb).to   eql('HEAD')  }
  end

  describe 'TRACE' do
    subject { described_class::TRACE }

    it { expect(subject).to be_trace }

    it { expect(subject).to_not be_get }
    it { expect(subject).to_not be_post }
    it { expect(subject).to_not be_put }
    it { expect(subject).to_not be_patch }
    it { expect(subject).to_not be_delete }
    it { expect(subject).to_not be_head }
    it { expect(subject).to_not be_options }
    it { expect(subject).to_not be_link }
    it { expect(subject).to_not be_unlink }

    it { expect(subject).to     be_safe       }
    it { expect(subject).to     be_idempotent }
    it { expect(subject).to_not be_cacheable  }

    it { expect(subject.allows_body?).to be(false) }

    it { expect(subject.to_sym).to equal(:trace) }
    it { expect(subject.to_s).to   eql('TRACE')  }
    it { expect(subject.verb).to   eql('TRACE')  }
  end

  describe 'OPTIONS' do
    subject { described_class::OPTIONS }

    it { expect(subject).to be_options }

    it { expect(subject).to_not be_get }
    it { expect(subject).to_not be_post }
    it { expect(subject).to_not be_put }
    it { expect(subject).to_not be_patch }
    it { expect(subject).to_not be_delete }
    it { expect(subject).to_not be_head }
    it { expect(subject).to_not be_trace }
    it { expect(subject).to_not be_link }
    it { expect(subject).to_not be_unlink }

    it { expect(subject).to     be_safe       }
    it { expect(subject).to     be_idempotent }
    it { expect(subject).to_not be_cacheable  }

    it { expect(subject.allows_body?).to be(true) }

    it { expect(subject.to_sym).to equal(:options) }
    it { expect(subject.to_s).to   eql('OPTIONS')  }
    it { expect(subject.verb).to   eql('OPTIONS')  }
  end

  describe 'LINK' do
    subject { described_class::LINK }

    it { expect(subject).to be_link }

    it { expect(subject).to_not be_get }
    it { expect(subject).to_not be_post }
    it { expect(subject).to_not be_put }
    it { expect(subject).to_not be_patch }
    it { expect(subject).to_not be_delete }
    it { expect(subject).to_not be_head }
    it { expect(subject).to_not be_trace }
    it { expect(subject).to_not be_options }
    it { expect(subject).to_not be_unlink }

    it { expect(subject).to_not be_safe       }
    it { expect(subject).to     be_idempotent }
    it { expect(subject).to_not be_cacheable  }

    it { expect(subject.allows_body?).to be(true) }

    it { expect(subject.to_sym).to equal(:link) }
    it { expect(subject.to_s).to   eql('LINK')  }
    it { expect(subject.verb).to   eql('LINK')  }
  end

  describe 'UNLINK' do
    subject { described_class::UNLINK }

    it { expect(subject).to be_unlink }

    it { expect(subject).to_not be_get }
    it { expect(subject).to_not be_post }
    it { expect(subject).to_not be_put }
    it { expect(subject).to_not be_patch }
    it { expect(subject).to_not be_delete }
    it { expect(subject).to_not be_head }
    it { expect(subject).to_not be_trace }
    it { expect(subject).to_not be_options }
    it { expect(subject).to_not be_link }

    it { expect(subject).to_not be_safe       }
    it { expect(subject).to     be_idempotent }
    it { expect(subject).to_not be_cacheable  }

    it { expect(subject.allows_body?).to be(true) }

    it { expect(subject.to_sym).to equal(:unlink) }
    it { expect(subject.to_s).to   eql('UNLINK')  }
    it { expect(subject.verb).to   eql('UNLINK')  }
  end

end
