require 'json'
require 'forwardable'

require "knish/version"
require "knish/db_config"
require "knish/collection_config"
require "knish/writer"
require "knish/reader"

module Knish
  def self.clear_config
    @config = nil
  end

  def self.config
    @config ||= DbConfig.new
  end

  def self.configure(&block)
    block.call(config)
  end
end

