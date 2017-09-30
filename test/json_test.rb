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

end
