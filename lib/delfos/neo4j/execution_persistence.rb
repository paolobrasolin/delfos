# frozen_string_literal: true
require_relative "query_execution"

module Delfos
  module Neo4j
    class ExecutionPersistence
      def self.save!(other)
        new(other.call_sites, other.execution_count).save!
      end

      def save!
        Neo4j::QueryExecution.execute(query, params)
      end

      private

      def initialize(call_sites, execution_count)
        @call_sites = call_sites

        @execution_count = execution_count
      end

      attr_reader :call_sites, :execution_count

      def query
        map_call_sites do |c,i|
          call_site_query(c, i)
        end.join("\n")
      end

      def params
        params = {}

        map_call_sites do |c,i|
          params.merge(call_site_params(c, i))
        end

        params
      end

      def map_call_sites
        call_sites.compact.map.with_index do |c, i|
          yield c, i
        end
      end

      def call_site_query(cs, i)
         <<-QUERY
          MERGE

          (k#{i}:{klass#{i}})

          - [:OWNS] ->

          (
            m#{i} :{method_type#{i}} {
              name: {method_name#{i}},
              file: {method_definition_file#{i}},
              line_number: {method_definition_line#{i}}}
          )

          MERGE

          (m#{i})

          -[:CONTAINS]->

          (cs#{i}:CallSite {file: {file#{i}}, line_number: {line_number#{i}}})

          MERGE (e#{i}:ExecutionChain{number: {execution_count}})

          MERGE (e#{i})
            -
            [:STEP{number: {step_number#{i}}}]
            ->
          (cs#{i})
        QUERY
      end

      def call_site_params(cs, i)
        {
          "klass#{i}"                  => cs.klass,
          "method_name#{i}"            => cs.method_name,
          "method_type#{i}"            => cs.method_type,
          "method_definition_file#{i}" => cs.method_definition_file,
          "execution_count#{i}"        => execution_count,
          "method_definition_line#{i}" => cs.method_definition_line,
          "file#{i}"                   => cs.file,
          "line_number#{i}"            => cs.line_number,
          "step_number#{i}"            => i + 1
        }
      end
    end
  end
end
