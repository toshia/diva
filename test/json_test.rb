# -*- coding: utf-8 -*-

require_relative 'test_helper'

describe 'Model' do
  describe 'empty' do
    before do
      @mk = Class.new(Diva::Model)
    end

    it '{}が得られる' do
      assert_equal '{}', @mk.new({}).to_json
    end
  end

  describe '数値キーをもつ' do
    before do
      @mk = Class.new(Diva::Model) do
        field.int :id, required: true
      end
    end

    it '{id:1}が得られる' do
      assert_equal '{"id":1}', @mk.new(id: 1).to_json
    end
  end

  describe 'Timeキーをもつ' do
    before do
      @mk = Class.new(Diva::Model) do
        field.time :created_at, required: true
      end
    end

    it 'iso8601エンコードされた値が得られる' do
      assert_equal '{"created_at":"2017-12-26T12:46:45+09:00"}', @mk.new(created_at: Time.new(2017, 12, 26, 12, 46, 45, '+09:00')).to_json
    end
  end

  describe 'TimeのArrayキーをもつ' do
    before do
      @mk = Class.new(Diva::Model) do
        field.has :timestamps, [:time], required: true
      end
    end

    it 'iso8601エンコードされた値の配列が得られる' do
      assert_equal '{"timestamps":["2017-12-26T12:46:45+09:00"]}', @mk.new(timestamps: [Time.new(2017, 12, 26, 12, 46, 45, '+09:00')]).to_json
    end

  end

  describe 'Modelキーをもつ' do
    before do
      cmk = Class.new(Diva::Model)
      @mk = Class.new(Diva::Model) do
        field.has :child, cmk, required: true
      end
    end
    it '{"child":{}}が得られる' do
      assert_equal '{"child":{}}', @mk.new(child:{}).to_json
    end
  end

  describe 'Arrayキーをもつ' do
    before do
      @mk = Class.new(Diva::Model) do
        field.has :ids, [:int], required: true
      end
    end

    it '{"ids":[1,2,3]}が得られる' do
      assert_equal '{"ids":[1,2,3]}', @mk.new(ids: [1,2,3]).to_json
    end

  end

  describe 'Unionキーを持つ' do
    describe 'AtomicとTime' do
      before do
        @mk = Class.new(Diva::Model) do
          field.has :union_test, [:bool, :time], required: true
        end
      end

      describe 'boolを格納' do
        it 'boolが得られる' do
          assert_equal '{"union_test":true}', @mk.new(union_test: true).to_json
        end
      end

      describe 'iso8601文字列を格納' do
        it 'iso8601文字列が得られる' do
          assert_equal '{"union_test":"2017-12-26T12:46:45+09:00"}', @mk.new(union_test: "2017-12-26T12:46:45+09:00").to_json
        end
      end

      describe 'Timeを格納' do
        it 'iso8601文字列が得られる' do
          assert_equal '{"union_test":"2017-12-26T12:46:45+09:00"}', @mk.new(union_test: Time.new(2017, 12, 26, 12, 46, 45, '+09:00')).to_json
        end
      end

    end
  end

end
