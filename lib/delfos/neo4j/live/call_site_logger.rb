# frozen_string_literal: true

require "delfos/neo4j/call_site_query"

module Delfos
  module Neo4j
    module Live
      class CallSiteLogger
        def log(call_site, stack_uuid, step_number)
          q = CallSiteQuery.new(call_site, stack_uuid, step_number)

          Neo4j.execute(q.query, q.params)
        end

        def finish!
          reset_call_stack!
          update_distance!
        end

        def reset!
          reset_call_stack!
          Neo4j.reset!
        end

        private

        def flush!
          Neo4j.flush!
        end

        def update_distance!
          Neo4j.update_distance!
          flush!
        end

        def reset_call_stack!
          Delfos::CallStack.pop_until_top!
          Delfos::CallStack.reset!
          flush!
        end
      end
    end
  end
end
