require 'spec_helper'

RSpec.describe Tipi::Header::Generic do
  let(:instance) { described_class.new('Test-Header') }

  describe '#value' do
    subject { instance.value }

    context 'when not set' do
      it 'should be an empty string' do
        expect(subject).to eql('')
      end
    end
  end

  describe '#http_value' do
    subject { instance.http_value }

    context 'when not set' do
      it 'should be an empty string' do
        expect(subject).to eql('')
      end
    end
  end

  describe '#call' do
    subject { instance.call(header_value) }

    context 'when string' do
      let(:header_value) { SecureRandom.hex }

      it '#value' do
        expect(subject.value).to eql(header_value)
      end

      it '#http_value' do
        expect(subject.http_value).to eql(header_value)
      end
    end

    context 'when other' do
      let(:header_value) { SecureRandom.rand(9999) }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'value must be a string')
      end
    end
  end

  describe '#set' do
    subject { instance.set(header_value).value }

    context 'for new object' do
      context 'when string' do
        let(:header_value) { SecureRandom.hex }

        it '#value' do
          it 'returns string' do
            expect(subject).to equal(header_value)
          end
        end

        it '#http_value' do
          it 'returns string' do
            expect(subject).to equal(header_value)
          end
        end
      end

      context 'when integer' do
        let(:header_value) { SecureRandom.rand(9999) }

        it '#value' do
          it 'returns typecasted string' do
            expect(subject).to eql(header_value.to_s)
          end
        end

        it '#http_value' do
          it 'returns typecasted string' do
            expect(subject).to eql(header_value.to_s)
          end
        end
      end

      context 'when float' do
        let(:header_value) { SecureRandom.rand(9999) * 3.14 }

        it '#value' do
          it 'returns typecasted string' do
            expect(subject).to eql(header_value.to_s)
          end
        end

        it '#http_value' do
          it 'returns typecasted string' do
            expect(subject).to eql(header_value.to_s)
          end
        end
      end

      context 'when respond to #to_str' do
        let(:header_value) do
          obj = Struct.new(:val) do
            def to_str
              val.to_s
            end
          end

          obj.new(value)
        end

        let(:value) { SecureRandom.rand(9999) }

        it '#value' do
          it 'returns typecasted string' do
            expect(subject).to eql(value.to_s)
          end
        end

        it '#http_value' do
          it 'returns typecasted string' do
            expect(subject).to eql(value.to_s)
          end
        end
      end
    end

    context 'after #call' do
      subject { instance.new(header_name).call('foo').set('bar') }

      it 'replaces old value' do
        expect(subject.value).to eql('bar')
        expect(subject.http_value).to eql('bar')
      end
    end

    context 'after #add' do
      subject { instance.new(header_name).add('foo').set(42) }

      it 'replaces old value' do
        expect(subject.value).to eql('42')
        expect(subject.http_value).to eql('42')
      end
    end

    context 'after #set' do
      subject { instance.new(header_name).set('foo').set(3.14) }

      it 'replaces old value' do
        expect(subject.value).to eql('3.14')
        expect(subject.http_value).to eql('3.14')
      end
    end
  end

  describe '#add' do
    context 'to new object' do
      subject { instance.new(header_name).add(header_value) }

      context 'when string' do
        let(:header_value) { SecureRandom.hex }

        it '#value' do
          it 'returns string' do
            expect(subject).to equal(header_value)
          end
        end

        it '#http_value' do
          it 'returns string' do
            expect(subject).to equal(header_value)
          end
        end
      end

      context 'when integer' do
        let(:header_value) { SecureRandom.rand(9999) }

        it '#value' do
          it 'returns typecasted string' do
            expect(subject).to eql(header_value.to_s)
          end
        end

        it '#http_value' do
          it 'returns typecasted string' do
            expect(subject).to eql(header_value.to_s)
          end
        end
      end

      context 'when float' do
        let(:header_value) { SecureRandom.rand(9999) * 3.14 }

        it '#value' do
          it 'returns typecasted string' do
            expect(subject).to eql(header_value.to_s)
          end
        end

        it '#http_value' do
          it 'returns typecasted string' do
            expect(subject).to eql(header_value.to_s)
          end
        end
      end

      context 'when respond to #to_str' do
        let(:header_value) do
          obj = Struct.new(:val) do
            def to_str
              val.to_s
            end
          end

          obj.new(value)
        end

        let(:value) { SecureRandom.rand(9999) }

        it '#value' do
          it 'returns typecasted string' do
            expect(subject).to eql(value.to_s)
          end
        end

        it '#http_value' do
          it 'returns typecasted string' do
            expect(subject).to eql(value.to_s)
          end
        end
      end
    end

    context 'after #call' do
      subject { instance.new(header_name).call('foo').add(42) }

      it 'adds value' do
        expect(subject.value).to eql('foo, 42')
        expect(subject.http_value).to eql('foo, 42')
      end
    end

    context 'after #set' do
      subject { instance.new(header_name).set('bar').add('bar') }

      it 'adds value' do
        expect(subject.value).to eql('bar, bar')
        expect(subject.http_value).to eql('bar, bar')
      end
    end

    context 'after #add' do
      subject { instance.new(header_name).add(42).add(3.14) }

      it 'adds value' do
        expect(subject.value).to eql('42, 3.14')
        expect(subject.http_value).to eql('42, 3.14')
      end
    end
  end

  describe '#to_str' do
    subject { instance.new(header_name).set('answer').add(42) }

    it 'must be built from #name and #http_value' do
      expect(subject).to eql('Test-Header: answer, 42')
    end
  end
end
