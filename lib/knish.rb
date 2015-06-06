require 'json'
require 'forwardable'
require 'delegate'
require 'fileutils'

require "knish/version"
require "knish/delegate_inspector"
require "knish/next_id"
require "knish/db_config"
require "knish/model_config"
require "knish/writer"
require "knish/reader"
require "knish/builder"
require "knish/model"
require "knish/collection"
require "knish/collection_config"
require "knish/collection_member"

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

  def self.build(path, &block)
    builder = Builder.new(path, &block)
    builder.make_model
  end
end
