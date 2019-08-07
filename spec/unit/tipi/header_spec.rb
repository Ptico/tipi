require 'spec_helper'

RSpec.describe Tipi::Header do
  describe 'ClassMethods' do
    around(:each) do |example|
      map_state = described_class.instance_variable_get(:"@mapping")
      reg_state = described_class.instance_variable_get(:"@registry")
      example.run
      described_class.instance_variable_set(:"@mapping", map_state)
      described_class.instance_variable_set(:"@registry", reg_state)
    end

    describe '.register' do
      let(:header) { Class.new(described_class) }

      context 'when header not registered' do
        before(:each) do
          described_class.register('Example-Header', header)
        end

        it 'should register header' do
          expect(described_class['Example-Header']).to be_instance_of(header)
        end
      end

      context 'when header is registered' do
        let(:old_header) { Class.new(described_class) }

        before(:each) do
          described_class.register('Popular-Header', old_header)
          described_class.register('Popular-Header', header)
        end

        it 'should register header' do
          expect(described_class['Popular-Header']).to be_instance_of(header)
        end
      end

      context 'when type assumed but not registered' do
        subject { described_class.register('Some-Header', :something) }

        it 'should raise exception and not register a header' do
          expect { subject }.to raise_error(Tipi::Header::NotRegistered, 'type ":something" is not in the list of known header type')
          expect(described_class.registered?('Some-Header')).to equal(false)
        end
      end
    end

    describe '.register_type' do
      let(:header_one) { Class.new(described_class) }

      before(:each) do
        described_class.register_type(:custom, header_one)
        described_class.register('X-Custom', :custom)
      end

      context 'when type is not registered' do
        it 'should register type' do
          expect(described_class['X-Custom']).to be_instance_of(header_one)
        end
      end

      context 'when type is registered' do
        before(:each) do
          described_class.register_type(:custom, header_two)
        end

        it 'should change a reference' do
          expect(described_class['X-Custom']).to be_instance_of(header_two)
        end
      end
    end

    describe '.registered?' do
      subject { described_class.registered?('Some-Header') }

      context 'when registered' do
        before(:each) do
          described_class.register('Some-Header', Class.new(described_class))
        end

        it { expect(subject).to be_truthy }
      end

      context 'when not registered' do
        it { expect(subject).to be_falsy }
      end
    end

    describe '.[]' do
      subject { described_class[header_name] }

      context 'when header is registered' do
        let(:header_class) { Class.new(described_class) }

        before(:each) do
          described_class.register('Some-Header', header_class)
        end

        context 'when header name is Canonical-Cased' do
          let(:header_name) { 'Some-Header' }

          it 'returns registered class' do
            expect(subject).to be_instance_of(header_class)
          end

          it '#name is in canonical case' do
            expect(subject.name).to eql('Some-Header')
          end
        end

        context 'when header name is down-cased' do
          let(:header_name) { 'some-header' }

          it 'returns registered class' do
            expect(subject).to be_instance_of(header_class)
          end

          it '#name is in canonical case' do
            expect(subject.name).to eql('Some-Header')
          end
        end
      end

      context 'when header is not registered' do
        context 'when header name is Canonical-Cased' do
          let(:header_name) { 'Some-Header' }

          it 'returns generic header' do
            expect(subject).to be_instance_of(Tipi::Header::Generic)
          end

          it '#name is in canonical case' do
            expect(subject.name).to eql('Some-Header')
          end
        end

        context 'when header name is down-cased' do
          let(:header_name) { 'some-header' }

          it 'returns generic header' do
            expect(subject).to be_instance_of(Tipi::Header::Generic)
          end

          it '#name is in canonical case' do
            expect(subject.name).to eql('Some-Header')
          end
        end
      end
    end
  end

  describe '#name' do
  end

  describe '#to_str' do
  end
end
