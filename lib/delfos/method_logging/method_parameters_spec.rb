# frozen_string_literal: true
require_relative "method_parameters"
require "./fixtures/b"
require "./fixtures/a"

module Delfos
  module MethodLogging
    describe MethodParameters do
      let(:a) { A.new }
      let(:b) { B.new }
      let(:c) { 1 }
      let(:d) { "" }
      let(:a_path) { File.expand_path "./fixtures/a.rb" }
      let(:b_path) { File.expand_path "./fixtures/b.rb" }

      let(:method_logging) do
        double("method_logging").tap do |m|
          allow(m).to receive(:include_file_in_logging?) do |file|
            [a_path, b_path].include?(file)
          end
        end
      end

      before do
        definition = lambda do |k|
          case k.to_s
          when "A"
            [a_path]
          when "B"
            [b_path]
          else
            ["/some-unincluded-path/example.rb", ]
          end
        end

        allow(Patching::MethodCache).
          to receive(:files_for, &definition)

        allow(Delfos).to receive(:method_logging).and_return method_logging
        path = Pathname.new(File.expand_path(__FILE__)) + "../../../../fixtures"
        Delfos.application_directories = [path]
      end

      subject { described_class.new([a, b, c, d], c: c, d: d) }

      describe "#args" do
        it do
          expect(subject.args).to eq [A, B]
        end
      end

      describe "#keyword_args" do
        it "ignores non application defined classes" do
          expect(subject.keyword_args).to eq []
        end
      end
    end
  end
end
