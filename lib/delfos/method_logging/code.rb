# frozen_string_literal: true
require_relative "klass_determination"

module Delfos
  module MethodLogging
    class Code
      extend Forwardable
      delegate [:object, :method_type, :method_name, :line_number, :method_definition_file,
                :method_definition_line] => :code_location

      attr_reader :code_location

      def initialize(code_location)
        @code_location = code_location
      end

      def self.from_caller(stack, caller_binding)
        location = CodeLocation.from_caller(stack, caller_binding)
        return unless location
        new location
      end

      def self.from_called(object, called_method, class_method)
        location = CodeLocation.from_called(object, called_method, class_method)
        return unless location
        new location
      end

      def file
        file = code_location.file.to_s

        if file
          Delfos.application_directories.map do |d|
            file = relative_path(file, d)
          end
        end

        file
      end

      def relative_path(file, dir)
        match = dir.to_s.split("/")[0..-2].join("/")

        if file[match]
          file = file.gsub(match, "").
                 gsub(%r{^/}, "")
        end

        file
      end

      def klass
        name = code_location.klass.name || "__AnonymousClass"
        name.tr ":", "_"
      end
    end

    # This magic number is determined based on the specific implementation now
    # E.g. if the line
    # where we call this `caller_binding.of_caller(stack_index + STACK_OFFSET).eval('self')`
    # is to be extracted into another method we will get a failing test and have to increment
    # the value
    STACK_OFFSET = 4

    class CodeLocation
      include KlassDetermination

      class << self
        def from_caller(stack, caller_binding)
          current = stack.detect do |s|
            file = s.split(":")[0]
            Delfos::MethodLogging.include_file_in_logging?(file)
          end

          return unless current

          stack_index = stack.index { |c| c == current }

          object = caller_binding.of_caller(stack_index + STACK_OFFSET).eval("self")
          class_method = object.kind_of? Module

          file, line_number, rest = current.split(":")
          method_name = rest[/`.*'$/]
          method_name = method_name.gsub("`", "").gsub("'", "")

          new(object, method_name.to_s, class_method, file, line_number.to_i)
        end

        def from_called(object, called_method, class_method)
          file, line_number = called_method.source_location

          new(object, called_method.name.to_s, class_method, file, line_number)
        end

        def method_type_from(class_method)
          class_method ? "ClassMethod" : "InstanceMethod"
        end

        def method_definition_for(klass, class_method, method_name)
          key = key_from(class_method, method_name)

          Delfos::Patching.added_methods[klass][key]
        end

        private

        def key_from(class_method, name)
          "#{method_type_from(class_method)}_#{name}"
        end
      end

      attr_reader :object, :method_name, :class_method, :method_type, :file, :line_number

      def initialize(object, method_name, class_method, file, line_number)
        @object = object
        @method_name = method_name
        @class_method = class_method
        @method_type = self.class.method_type_from class_method 
        @file = file
        @line_number = line_number
      end

      def method_definition_file
        method_definition[0]
      end

      def method_definition_line
        method_definition[1]
      end

      def klass
        klass_for(object)
      end

      private

      def method_key
        "#{method_type}_#{method_name}"
      end

      def method_definition
        @method_definition ||= self.class.method_definition_for(klass, class_method, method_name)
      end
    end
  end
end
