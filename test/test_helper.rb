# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "test"
end

require "minitest/autorun"
require "minitest/reporters"
require "logger2r"
require "yaml"

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

module TestHelper
  TESTS_DIR = File.expand_path(File.dirname(__FILE__))
  SUPPORT_DIR = File.join TESTS_DIR, "support"
  MONGO_CONFIG = YAML.load_file(File.join(SUPPORT_DIR, "test_mongo_config.yml"))
end

Logger2r.config_file = File.join(TestHelper::SUPPORT_DIR, "test_logger_config.yml")
