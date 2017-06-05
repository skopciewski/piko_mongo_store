# frozen_string_literal: true

require "test_helper"
require "piko_mongo_store/db_factory"

module PikoMongoStore
  class DbFactoryTest < Minitest::Test
    def setup
      @config = TestHelper::MONGO_CONFIG
    end

    def test_that_it_creates_client_object
      db = DbFactory.create_db_connection(@config)
      assert_equal Mongo::Client, db.class
    end

    def test_that_connection_is_reused_for_the_same_config
      db1 = DbFactory.create_db_connection(@config)
      db2 = DbFactory.create_db_connection(@config)
      assert_same db1, db2
    end
  end
end
