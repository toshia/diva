# -*- coding: utf-8 -*-

require_relative 'test_helper'

describe 'URI' do
  describe 'httpスキーム' do
    before do
      @uri = Diva::URI('http://mikutter.hachune.net/')
    end

    it '文字列表現を得ることができる' do
      assert_equal 'http://mikutter.hachune.net/', @uri.to_s
    end

    describe '情報を得る' do
      it 'scheme' do
        assert_equal 'http', @uri.scheme
      end

      it 'host' do
        assert_equal 'mikutter.hachune.net', @uri.host
      end

      it 'path' do
        assert_equal '/', @uri.path
      end
    end

    describe '比較' do
      it '一致するString' do
        assert @uri == 'http://mikutter.hachune.net/'
      end

      it 'URIではないString' do
        refute @uri == 'テストテキスト'
      end

      it '一致するURI' do
        assert @uri == URI.parse('http://mikutter.hachune.net/')
      end

      it '一致するAddressableURI' do
        assert @uri == Addressable::URI.parse('http://mikutter.hachune.net/')
      end
    end
  end
end
