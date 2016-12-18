require "spec_helper"
require_relative "method_arguments"

module Delfos
  module Patching
    describe MethodArguments  do
      let(:block) { nil }
      let(:keyword_args) { {} }
      let(:args) { [] }
      let(:should_wrap_exception) { true }
      let(:instance) { described_class.new(args, keyword_args, block, should_wrap_exception)  }

      describe "#apply_to" do
        context "with exception wrapping disabled" do
          let(:should_wrap_exception) { false }
          let(:bomb) { lambda{raise "boom" } }

          it do
            expect(->{ instance.apply_to(bomb)}).to raise_error RuntimeError
          end
        end
        context "with exception wrapping enabled" do
          let(:should_wrap_exception) { true }
          let(:bomb) { lambda{raise "boom" } }

          it do
            expect(->{
              instance.apply_to(bomb)
            }).to raise_error Delfos::MethodCallingException
          end
        end
      end
    end
  end
end

