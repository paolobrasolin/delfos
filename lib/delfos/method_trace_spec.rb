# frozen_string_literal: true

require_relative "method_trace"
require "./fixtures/a"

module Delfos
  RSpec.describe MethodTrace do
    let(:return_handler) { double "Return Handler", perform: nil }
    let(:call_handler) { double "Call Handler", perform: nil }
    let(:raise_handler) { double "Raise Handler", perform: nil }

    before do
      Delfos.configure { |c| c.application_directories = "fixtures" }
      # we manually start the TracePoints in our tests so
      # disable the automatically started ones
      described_class.disable!
    end

    after do
      described_class.disable!
    end

    describe "on_call" do
      before do
        expect(MethodTrace::CallHandler).
          to receive(:new).
          and_return(call_handler).
          at_least(:once)
      end
      it do
        expect(call_handler).to receive(:perform).at_least(:once)

        described_class.on_call.enable
        A.new.some_method
      end
    end

    describe "on_return" do
      it do
        expect(CallStack).to receive(:pop).at_least(:once)

        described_class.on_return.enable
        A.new.some_method
      end
    end
  end
end
