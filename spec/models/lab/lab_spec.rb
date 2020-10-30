# frozen_string_literal: true

require 'support/shoulda'

RSpec.describe Lab do
  it 'has a valid factory' do
    expect(FactoryBot.build(:lab)).to be_valid
  end

  it { is_expected.to validate_presence_of :analytics }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :keywords }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :version }

  it { expect(FactoryBot.build(:lab)).to validate_uniqueness_of(:title).case_insensitive }

  describe '.download' do
    let(:lab) { FactoryBot.build :lab }

    it 'return the github download url' do
      expect(lab.download).to eq "https://github.com/#{CONFIG['github']}/#{lab.slug}/archive/#{lab.version}.zip"
    end
  end

  describe '.javascripts' do
    context 'with value' do
      context 'with single file' do
        let(:lab) { FactoryBot.build :lab, js_import: 'https://example.org' }

        it 'returns the urls wrapped with script tag' do
          expect(lab.javascripts).to eq %(<script src="https://example.org"></script>)
        end
      end

      context 'with multiple files' do
        context 'with spaces' do
          let(:lab) { FactoryBot.create :lab, js_import: 'https://example.org, https://example.com' }

          it 'returns the urls wrapped with script tag' do
            expect(lab.javascripts).to eq %(<script src="https://example.org"></script><script src="https://example.com"></script>)
          end
        end

        context 'without spaces' do
          let(:lab) { FactoryBot.build :lab, js_import: 'https://example.org,https://example.com' }

          it 'returns the urls wrapped with script tag' do
            expect(lab.javascripts).to eq %(<script src="https://example.org"></script><script src="https://example.com"></script>)
          end
        end
      end
    end

    context 'without value' do
      let(:lab) { FactoryBot.build :lab, js_import: nil }

      it 'returns nothing' do
        expect(lab.javascripts).to be_nil
      end
    end
  end

  describe '.javascripts_inline' do
    context 'with value' do
      let(:lab) { FactoryBot.build :lab, js: '$("div").raty();' }

      it 'returns the content without wrap' do
        expect(lab.javascripts_inline).to eq '$("div").raty();'
      end
    end

    context 'with value' do
      let(:lab) { FactoryBot.build :lab, js: nil }

      it 'returns nothing' do
        expect(lab.javascripts_inline).to be_nil
      end
    end
  end

  describe '.javascripts_ready' do
    context 'with value' do
      let(:lab) { FactoryBot.build :lab, js_ready: '$("div").raty();' }

      it 'returns the content without wrap' do
        expect(lab.javascripts_ready).to eq '$("div").raty();'
      end
    end

    context 'with value' do
      let(:lab) { FactoryBot.build :lab, js_ready: nil }

      it 'returns nothing' do
        expect(lab.javascripts_ready).to be_nil
      end
    end
  end

  describe '.stylesheets' do
    context 'with value' do
      context 'with single file' do
        let(:lab) { FactoryBot.build :lab, css_import: 'https://example.org' }

        it 'returns the urls wrapped with link tag' do
          expect(lab.stylesheets).to eq %(<link rel="stylesheet" href="https://example.org">)
        end
      end

      context 'with multiple files' do
        context 'with spaces' do
          let(:lab) { FactoryBot.create :lab, css_import: 'https://example.org, https://example.com' }

          it 'returns the urls wrapped with link tag' do
            expect(lab.stylesheets).to eq %(<link rel="stylesheet" href="https://example.org"><link rel="stylesheet" href="https://example.com">)
          end
        end

        context 'without spaces' do
          let(:lab) { FactoryBot.build :lab, css_import: 'https://example.org,https://example.com' }

          it 'returns the urls wrapped with link tag' do
            expect(lab.stylesheets).to eq %(<link rel="stylesheet" href="https://example.org"><link rel="stylesheet" href="https://example.com">)
          end
        end
      end
    end

    context 'without value' do
      let(:lab) { FactoryBot.build :lab, css_import: nil }

      it 'returns nothing' do
        expect(lab.stylesheets).to be_nil
      end
    end
  end

  describe '.stylesheets_inline' do
    context 'with value' do
      let(:lab) { FactoryBot.build :lab, css: 'i { float: left }' }

      it 'returns the original content' do
        expect(lab.stylesheets_inline).to eq %(<style>i { float: left }</style>)
      end
    end

    context 'without value' do
      let(:lab) { FactoryBot.build :lab, css: nil }

      it 'returns nothing' do
        expect(lab.stylesheets_inline).to be_nil
      end
    end
  end
end
