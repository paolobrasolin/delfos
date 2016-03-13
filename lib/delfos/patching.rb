# frozen_string_literal: true
module Delfos
  class Patching
    def self.setup_method_call_logging(klass, name, private_methods, class_method:)
      new(klass, name, private_methods, class_method).setup
    end

    attr_reader :klass, :name, :private_methods, :class_method

    def initialize(klass, name, private_methods, class_method)
      @klass = klass
      @name = name
      @private_methods = private_methods
      @class_method = class_method
    end

    def setup
      return if bail?
      record_method_adding!
      original_method = original_method()
      class_method = class_method()

      method_defining_method.call(name) do |*args, **keyword_args, &block|
        ::Delfos::MethodLogging.log(
          self,
          args, keyword_args, block,
          class_method, caller.dup, binding.dup,
          original_method
        )

        method_to_call = class_method ? original_method : original_method.bind(self)

        if keyword_args.empty?
          method_to_call.call(*args, &block)
        else
          method_to_call.call(*args, **keyword_args, &block)
        end
      end
    end

    private

    def bail?
      already_added? || is_private_method? || exclude?
    end

    def is_private_method?
      private_methods.include?(name.to_sym)
    end

    def exclude?
      ::Delfos::MethodLogging.exclude_from_logging?(original_method)
    end

    def already_added?
      method_has_been_added?(klass, name, class_method: class_method)
    end

    def original_method
      @original_methods ||= class_method ? klass.singleton_method(name) : klass.instance_method(name)
    end

    def method_defining_method
      class_method ? klass.method(:define_singleton_method) : klass.method(:define_method)
    end

    def method_has_been_added?(klass, name, class_method:)
      return false unless self.class.added_methods[self]
      return false unless self.class.added_methods[self][klass]

      type = class_method ? "class_method" : "instance_method"
      self.class.added_methods[klass]["#{type}_#{name}"]
    end

    def self.added_methods
      @added_methods ||= {}
    end

    def record_method_adding!
      return true if method_has_been_added?(klass, original_method, class_method: class_method)

      self.class.added_methods[klass] ||= {}
      self.class.added_methods[klass][key] = original_method.source_location
    end

    def key
      "#{type}_#{original_method.name}"
    end

    def type 
      class_method ? "class_method" : "instance_method"
    end
  end
end