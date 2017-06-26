# frozen_string_literal: true

require "delfos/config"
require "forwardable"
require "delfos/method_trace"
require "delfos/neo4j/offline/importer"

module Delfos
  class << self
    extend Forwardable

    def_delegators :config,
      :batch_size,
      :call_site_logger,
      :logger,
      :max_query_size,
      :offline_query_saving,
      :offline_query_filename

    def config
      @config ||= Delfos::Config.new
    end

    def configure
      yield config
    end

    def start!
      ::Delfos::MethodTrace.trace!
    end

    def reset_config!
      @config = nil
    end

    def finish!
      ::Delfos::MethodTrace.disable!

      config.call_site_logger.finish!
    end

    def import_offline_queries(filename)
      Neo4j::Offline::Importer.new(filename).perform
    end

    def include_file?(file)
      config.include?(file)
    end
  end
end
