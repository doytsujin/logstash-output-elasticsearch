require "logstash/devutils/rspec/spec_helper"
require 'manticore'
require 'elasticsearch'

module ESHelper
  def get_host_port
    "127.0.0.1:9200"
  end

  def get_client
    Elasticsearch::Client.new(:hosts => [get_host_port])
  end

  def self.es_version
    RSpec.configuration.filter[:es_version] || ENV['ES_VERSION']
  end

  def self.es_version_satisfies?(*requirement)
    es_version = RSpec.configuration.filter[:es_version] || ENV['ES_VERSION']
    if es_version.nil?
      puts "Info: ES_VERSION environment or 'es_version' tag wasn't set. Returning false to all `es_version_satisfies?` call."
      return false
    end
    es_release_version = Gem::Version.new(es_version).release
    Gem::Requirement.new(requirement).satisfied_by?(es_release_version)
  end
end

RSpec.configure do |config|
  config.include ESHelper
end
