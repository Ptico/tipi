require 'spec_helper'

RSpec.describe Tipi::Header::Generic do
  let(:instance) { described_class.new('Test-Header') }

  describe 'tl;dr' do
    describe 'this is default header implementation' do
      it 'keeps incoming headers untouched' do
        # The same as Tipi::Header['Some-Header']
        header = described_class.new('Some-Header')
        header.('very; weird=header=value')
        expect(header.value).to eql('very; weird=header=value')
      end

      it 'set string values as is' do
        header = described_class.new('Header-Name')
        header.set('token; option=1')
        expect(header.value).to eql('token; option=1')
        expect(header.to_str).to eql('Some-Header: token; option=1')
      end

      it 'typecasts values' do
        header = described_class.new('Answer')
        header.set(42)
        expect(header.value).to eql('42')
        expect(header.to_str).to eql('Answer: 42')
      end

      it 'joins hash values' do
        header = described_class.new('Hash')
        header.set({ string: 'value', 'one' => 1 })
        expect(header.value).to eql('string=value, one=1')
        expect(header.to_str).to eql('Hash: string=value, one=1')
      end

      it 'joins arrays' do
        header = described_class.new('Math')
        header.set(['number', {'Pi' => 3.14 }, 16956])
        expect(header.value).to eql('number, Pi=3,14')
        expect(header.to_str).to eql('Math: number, Pi=3.14, 16956')
      end

      it 'add values' do
        header = described_class.new('X-Content')
        header.set('existing')
        header.add('additional')
        expect(header.value).to eql('existing, additional')
        expect(header.to_str).to eql('X-Content: existing, additional')
      end

      it 'may build a little bit more complex values' do
        header = described_class.new('Set-Something')
        header.set('token;')
        header.add({ option: 1 })
        expect(header.value).to eql('token; option=1')
      end
    end
  end

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

      context 'when hash' do
        let(:header_value) do
          { a: 1, 'foo' => 'bar' }
        end

        it '#value' do
          it 'returns pairs of key=values' do
            expect(subject).to eql('a=1, foo=bar')
          end
        end

        it '#http_value' do
          it 'returns pairs of key=values' do
            expect(subject).to eql('a=1, foo=bar')
          end
        end
      end

      context 'whan array' do
        let(:header_value) do
          [ 'foo', 42, { a: 1 }]
        end

        it '#value' do
          it 'returns pairs of key=values' do
            expect(subject).to eql('foo, 42, a=1')
          end
        end

        it '#http_value' do
          it 'returns pairs of key=values' do
            expect(subject).to eql('foo, 42, a=1')
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
      subject { instance.new(header_name).set('foo').set(['bar', 69]) }

      it 'replaces old value' do
        expect(subject.value).to eql('bar, 69')
        expect(subject.http_value).to eql('bar, 69')
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

      context 'when hash' do
        let(:header_value) do
          { 'hello' => 7.8, b: 'world' }
        end

        it '#value' do
          it 'returns pairs of key=values' do
            expect(subject).to eql('hello=7.8, b=world')
          end
        end

        it '#http_value' do
          it 'returns pairs of key=values' do
            expect(subject).to eql('hello=7.8, b=world')
          end
        end
      end

      context 'whan array' do
        let(:header_value) do
          [ 'hello', 7.8, { b: 'world' }]
        end

        it '#value' do
          it 'returns pairs of key=values' do
            expect(subject).to eql('hello, 7.8, b=world')
          end
        end

        it '#http_value' do
          it 'returns pairs of key=values' do
            expect(subject).to eql('hello, 7.8, b=world')
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
      subject { instance.new(header_name).add(42).add(['route', 66]) }

      it 'adds value' do
        expect(subject.value).to eql('42, route, 66')
        expect(subject.http_value).to eql('42, route, 66')
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
