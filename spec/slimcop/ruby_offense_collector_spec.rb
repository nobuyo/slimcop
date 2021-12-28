# frozen_string_literal: true

require 'rubocop'

RSpec.describe Slimcop::RubyOffenseCollector do
  describe '#call' do
    subject do
      described_class.new(
        auto_correct: false,
        file_path: 'dummy.slim',
        rubocop_config: RuboCop::ConfigLoader.default_configuration,
        source: source
      ).call
    end

    let(:source) do
      <<~RUBY
        "a"
      RUBY
    end

    context 'with valid condition' do
      it 'collects offenses from given Ruby code' do
        is_expected.to be_a(Array)
        expect(subject.length).to eq(2)
      end
    end

    context 'with rubocop:disabled comment' do
      let(:source) do
        <<~RUBY
          "a" \# rubocop:disable Style/StringLiterals
        RUBY
      end

      it 'excludes disabled offenses' do
        is_expected.to be_a(Array)
        expect(subject.length).to eq(1)
      end
    end
  end
end
