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

  describe '非ASCII文字host' do
    before do
      @uri = Diva::URI('https://こっち.みんな/ておくれ')
    end

    it '文字列表現を得ることができる' do
      assert_equal 'https://こっち.みんな/ておくれ', @uri.to_s
    end

    describe '情報を得る' do
      it 'scheme' do
        assert_equal 'https', @uri.scheme
      end

      it 'host' do
        assert_equal 'こっち.みんな', @uri.host
      end

      it 'path' do
        assert_equal '/ておくれ', @uri.path
      end
    end

    describe '比較' do
      it '一致するString' do
        assert @uri == 'https://こっち.みんな/ておくれ'
      end

      it 'URIではないString' do
        refute @uri == 'テストテキスト'
      end

      it '一致するAddressableURI' do
        assert @uri == Addressable::URI.parse('https://こっち.みんな/ておくれ')
      end
    end
  end
end
