# frozen_string_literal: true

require "test_helper"
require "piko_mongo_store/safe"
require "piko_mongo_store/db_factory"

module PikoMongoStore
  class SafeTest < Minitest::Test
    def setup
      config = TestHelper::MONGO_CONFIG
      @db = DbFactory.create_db_connection(config)
      @facade = Safe.new(@db)
    end

    def teardown
      @db[:coll].drop
    end

    def test_that_facade_returns_true_when_insert
      assert_same(true, @facade.execute { |db| db[:coll].insert_one(foo: :bar) })
    end

    def test_that_facade_returns_false_when_error_during_insert
      @db.stub(:[], proc { raise Mongo::Error::MaxBSONSize }) do
        assert_same(false, @facade.execute { |db| db[:coll].insert_one(foo: :bar) })
      end
    end

    def test_that_facade_returns_true_when_delete
      @db[:coll].insert_many [{ foo: :bar }, { foo: :baz }]
      assert_same(true, @facade.execute { |db| db[:coll].delete_one(foo: :bar) })
    end

    def test_that_facade_returns_false_when_error_during_delete
      @db.stub(:[], proc { raise Mongo::Error::MaxBSONSize }) do
        assert_same(false, @facade.execute { |db| db[:coll].delete_one(foo: :bar) })
      end
    end

    def test_that_facade_returns_true_when_nothing_to_delete
      assert_same(true, @facade.execute { |db| db[:coll].delete_one(foo: :bar) })
    end

    def test_that_facade_returns_true_when_delete_many
      @db[:coll].insert_many [{ foo: :bar }, { foo: :bar }]
      assert_same(true, @facade.execute { |db| db[:coll].delete_many(foo: :bar) })
    end

    def test_that_facade_returns_false_when_error_during_delete_many
      @db.stub(:[], proc { raise Mongo::Error::MaxBSONSize }) do
        assert_same(false, @facade.execute { |db| db[:coll].delete_many(foo: :bar) })
      end
    end

    def test_that_facade_returns_true_when_nothing_to_delete_many
      assert_same(true, @facade.execute { |db| db[:coll].delete_many(foo: :bar) })
    end

    def test_that_facade_returns_true_when_find_and_delete
      @db[:coll].insert_many [{ foo: :bar }, { foo: :baz }]
      assert_same(true, @facade.execute { |db| db[:coll].find(foo: :bar).find_one_and_delete })
    end

    def test_that_facade_returns_false_when_error_during_find_and_delete
      @db.stub(:[], proc { raise Mongo::Error::MaxBSONSize }) do
        assert_same(false, @facade.execute { |db| db[:coll].find(foo: :bar).find_one_and_delete })
      end
    end

    def test_that_facade_returns_true_when_nothing_to_find_and_delete
      assert_same(true, @facade.execute { |db| db[:coll].find(foo: :bar).find_one_and_delete })
    end

    def test_that_facade_gives_founded_doc_to_block_when_find_and_delete
      @db[:coll].insert_many [{ foo: :bar }, { foo: :baz }]
      spy = :unknown
      success_action = proc { |res| spy = res }
      @facade.execute(success_action) { |db| db[:coll].find(foo: :bar).find_one_and_delete }
      assert_equal :bar, spy[:foo]
    end

    def test_that_facade_gives_empty_doc_to_block_when_nothing_to_find_and_delete
      spy = :unknown
      success_action = proc { |res| spy = res }
      @facade.execute(success_action) { |db| db[:coll].find(foo: :bar).find_one_and_delete }
      assert_equal({}, spy)
    end

    def test_that_facade_returns_true_when_finds_doc
      @db[:coll].insert_many [{ foo: :bar }, { foo: :baz }]
      assert_same(true, @facade.execute { |db| db[:coll].find(foo: :bar).first })
    end

    def test_that_facade_returns_false_when_error_during_finding_doc
      @db.stub(:[], proc { raise Mongo::Error::MaxBSONSize }) do
        assert_same(false, @facade.execute { |db| db[:coll].find(foo: :bar).first })
      end
    end

    def test_that_facade_returns_true_when_can_not_find_doc
      assert_same(true, @facade.execute { |db| db[:coll].find(foo: :bar).first })
    end

    def test_that_facade_gives_founded_doc_to_block_when_find
      @db[:coll].insert_many [{ foo: :bar }, { foo: :baz }]
      spy = :unknown
      success_action = proc { |res| spy = res }
      @facade.execute(success_action) { |db| db[:coll].find(foo: :bar).first }
      assert_equal :bar, spy[:foo]
    end

    def test_that_facade_gives_empty_doc_to_block_when_can_not_find
      spy = :unknown
      success_action = proc { |res| spy = res }
      @facade.execute(success_action) { |db| db[:coll].find(foo: :bar).first }
      assert_equal({}, spy)
    end

    def test_that_facade_returns_true_when_finds_many_docs
      @db[:coll].insert_many [{ foo: :bar }, { foo: :bar }]
      assert_same(true, @facade.execute { |db| db[:coll].find(foo: :bar) })
    end

    def test_that_facade_returns_false_when_error_during_finding_many_docs
      @db.stub(:[], proc { raise Mongo::Error::MaxBSONSize }) do
        assert_same(false, @facade.execute { |db| db[:coll].find(foo: :bar) })
      end
    end

    def test_that_facade_returns_true_when_can_not_find_many_docs
      assert_same(true, @facade.execute { |db| db[:coll].find(foo: :bar) })
    end

    def test_that_facade_gives_founded_docs_to_block_when_find_many
      @db[:coll].insert_many [{ foo: :bar }, { foo: :bar }]
      spy = :unknown
      success_action = proc { |res| spy = res }
      @facade.execute(success_action) { |db| db[:coll].find(foo: :bar) }
      assert_equal 2, spy.count
    end

    def test_that_facade_gives_empty_enum_to_block_when_can_not_find_many
      spy = :unknown
      success_action = proc { |res| spy = res }
      @facade.execute(success_action) { |db| db[:coll].find(foo: :bar) }
      assert_equal 0, spy.count
    end
  end
end
