# -*- coding: utf-8 -*-

require_relative 'test_helper'

describe 'Type' do
  #
  # INT
  #
  describe 'INT' do
    it 'nameが"int"' do
      assert_equal :int, Diva::Type::INT.name
    end

    describe 'キャスト' do
      it 'intから' do
        assert_equal 39, Diva::Type::INT.cast(39)
      end

      it 'floatから' do
        assert_equal 39.25.to_i, Diva::Type::INT.cast(39.25)
      end

      describe 'boolから' do
        it 'true' do
          assert_equal 1, Diva::Type::INT.cast(true)
        end
        it 'false' do
          assert_equal 0, Diva::Type::INT.cast(false)
        end
      end

      describe 'stringから' do
        it '"39"を' do
          assert_equal 39, Diva::Type::INT.cast("39")
        end
        it '"abc"を' do
          assert_equal 0, Diva::Type::INT.cast("abc")
        end
      end

      it 'Timeから' do
        time = Time.new(2009, 12, 25)
        assert_equal time.to_i, Diva::Type::INT.cast(time)
      end

      it 'URI::Genericから' do
        uri = URI.parse('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::INT.cast(uri)
        end
      end

      it 'Diva::URIから' do
        uri = Diva::URI.new('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::INT.cast(uri)
        end
      end

      it 'Addressable::URIから' do
        uri = Addressable::URI.parse('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::INT.cast(uri)
        end
      end

      it 'Modelから' do
        mk = Class.new(Diva::Model)
        mi = mk.new({})
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::INT.cast(mi)
        end
      end

      it '配列から' do
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::INT.cast(['156'])
        end
      end
    end
  end

  #
  # FLOAT
  #
  describe 'FLOAT' do
    it 'nameが"float"' do
      assert_equal :float, Diva::Type::FLOAT.name
    end

    describe 'キャスト' do
      it 'intから' do
        assert_equal 39, Diva::Type::FLOAT.cast(39)
        assert_kind_of Float, Diva::Type::FLOAT.cast(39)
      end

      it 'floatから' do
        assert_equal 39.25, Diva::Type::FLOAT.cast(39.25)
      end

      describe 'boolから' do
        it 'true' do
          assert_raises(Diva::InvalidTypeError) do
            Diva::Type::FLOAT.cast(true)
          end
        end
        it 'false' do
          assert_raises(Diva::InvalidTypeError) do
            Diva::Type::FLOAT.cast(false)
          end
        end
      end

      describe 'stringから' do
        it '"39"を' do
          assert_equal 39.0, Diva::Type::FLOAT.cast("39")
        end
        it '"abc"を' do
          assert_equal 0.0, Diva::Type::FLOAT.cast("abc")
        end
      end

      it 'Timeから' do
        time = Time.new(2009, 12, 25)
        assert_equal time.to_f, Diva::Type::FLOAT.cast(time)
      end

      it 'URI::Genericから' do
        uri = URI.parse('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::FLOAT.cast(uri)
        end
      end

      it 'Diva::URIから' do
        uri = Diva::URI.new('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::FLOAT.cast(uri)
        end
      end

      it 'Addressable::URIから' do
        uri = Addressable::URI.parse('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::FLOAT.cast(uri)
        end
      end

      it 'Modelから' do
        mk = Class.new(Diva::Model)
        mi = mk.new({})
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::FLOAT.cast(mi)
        end
      end

      it '配列から' do
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::FLOAT.cast(['156'])
        end
      end
    end
  end

  #
  # BOOL
  #
  describe 'BOOL' do
    it 'nameが"bool"' do
      assert_equal :bool, Diva::Type::BOOL.name
    end

    describe 'キャスト' do
      describe 'intから' do
        it '0' do
          assert_equal false, Diva::Type::BOOL.cast(0)
        end

        it '非0' do
          assert_equal true, Diva::Type::BOOL.cast(1)
        end
      end

      it 'floatから' do
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::BOOL.cast(39.25)
        end
      end

      describe 'boolから' do
        it 'true' do
          assert_equal true, Diva::Type::BOOL.cast(true)
        end
        it 'false' do
          assert_equal false, Diva::Type::BOOL.cast(false)
        end
      end

      describe 'stringから' do
        it '"39"を' do
          assert_equal true, Diva::Type::BOOL.cast("39")
        end
        it '"abc"を' do
          assert_equal true, Diva::Type::BOOL.cast("abc")
        end
        it '"false"を' do
          assert_equal true, Diva::Type::BOOL.cast("false")
        end
        it '"nil"を' do
          assert_equal true, Diva::Type::BOOL.cast("nil")
        end
        it '"null"を' do
          assert_equal true, Diva::Type::BOOL.cast("null")
        end
        it '"0"を' do
          assert_equal true, Diva::Type::BOOL.cast("0")
        end
        it '""を' do
          assert_equal false, Diva::Type::BOOL.cast("")
        end
      end

      it 'Timeから' do
        time = Time.new(2009, 12, 25)
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::BOOL.cast(time)
        end
      end

      it 'URI::Genericから' do
        uri = URI.parse('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::BOOL.cast(uri)
        end
      end

      it 'Diva::URIから' do
        uri = Diva::URI.new('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::BOOL.cast(uri)
        end
      end

      it 'Addressable::URIから' do
        uri = Addressable::URI.parse('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::BOOL.cast(uri)
        end
      end

      it 'Modelから' do
        mk = Class.new(Diva::Model)
        mi = mk.new({})
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::BOOL.cast(mi)
        end
      end

      it '配列から' do
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::BOOL.cast(['156'])
        end
      end
    end
  end

  #
  # STRING
  #
  describe 'STRING' do
    it 'nameが"string"' do
      assert_equal :string, Diva::Type::STRING.name
    end

    describe 'キャスト' do
      it 'intから' do
        assert_equal "39", Diva::Type::STRING.cast(39)
      end

      it 'floatから' do
        assert_equal "39.25", Diva::Type::STRING.cast(39.25)
      end

      describe 'boolから' do
        it 'true' do
          assert_equal 'true', Diva::Type::STRING.cast(true)
        end
        it 'false' do
          assert_equal 'false', Diva::Type::STRING.cast(false)
        end
      end

      describe 'stringから' do
        it '"39"を' do
          assert_equal '39', Diva::Type::STRING.cast("39")
        end
        it '"abc"を' do
          assert_equal 'abc', Diva::Type::STRING.cast("abc")
        end
      end

      it 'Timeから' do
        time = Time.new(2009, 12, 25)
        assert_equal time.to_s, Diva::Type::STRING.cast(time)
      end

      it 'URI::Genericから' do
        expect = 'http://mikutter.hachune.net/'
        uri = URI.parse(expect)
        assert_equal expect, Diva::Type::STRING.cast(uri)
      end

      it 'Diva::URIから' do
        expect = 'http://mikutter.hachune.net/'
        uri = Diva::URI.new(expect)
        assert_equal expect, Diva::Type::STRING.cast(uri)
      end

      it 'Addressable::URIから' do
        expect = 'http://mikutter.hachune.net/'
        uri = Addressable::URI.parse(expect)
        assert_equal expect, Diva::Type::STRING.cast(uri)
      end

      it 'Modelから' do
        mk = Class.new(Diva::Model)
        mi = mk.new({})
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::STRING.cast(mi)
        end
      end

      it '配列から' do
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::STRING.cast(['156'])
        end
      end
    end
  end

  #
  # TIME
  #
  describe 'TIME' do
    it 'nameが"time"' do
      assert_equal :time, Diva::Type::TIME.name
    end

    describe 'キャスト' do
      it 'intから' do
        assert_equal Time.at(39), Diva::Type::TIME.cast(39)
      end

      it 'floatから' do
        assert_equal Time.at(39.25), Diva::Type::TIME.cast(39.25)
      end

      describe 'boolから' do
        it 'true' do
          assert_raises(Diva::InvalidTypeError) do
            Diva::Type::TIME.cast(true)
          end
        end
        it 'false' do
          assert_raises(Diva::InvalidTypeError) do
            Diva::Type::TIME.cast(false)
          end
        end
      end

      describe 'stringから' do
        it '"39"を' do
          assert_equal Time.new(39), Diva::Type::TIME.cast("39")
        end
        it '"abc"を' do
          assert_equal Time.new("abc"), Diva::Type::TIME.cast("abc")
        end
      end

      it 'Timeから' do
        time = Time.new(2009, 12, 25)
        assert_equal time, Diva::Type::TIME.cast(time)
      end

      it 'URI::Genericから' do
        uri = URI.parse('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::TIME.cast(uri)
        end
      end

      it 'Diva::URIから' do
        uri = Diva::URI.new('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::TIME.cast(uri)
        end
      end

      it 'Addressable::URIから' do
        uri = Addressable::URI.parse('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::TIME.cast(uri)
        end
      end

      it 'Modelから' do
        mk = Class.new(Diva::Model)
        mi = mk.new({})
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::TIME.cast(mi)
        end
      end

      it '配列から' do
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::TIME.cast(['156'])
        end
      end
    end
  end

  #
  # URI
  #
  describe 'URI' do
    it 'nameが"uri"' do
      assert_equal :uri, Diva::Type::URI.name
    end

    describe 'キャスト' do
      it 'intから' do
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::URI.cast(39)
        end
      end

      it 'floatから' do
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::URI.cast(39.25)
        end
      end

      describe 'boolから' do
        it 'true' do
          assert_raises(Diva::InvalidTypeError) do
            Diva::Type::URI.cast(true)
          end
        end
        it 'false' do
          assert_raises(Diva::InvalidTypeError) do
            Diva::Type::URI.cast(false)
          end
        end
      end

      describe 'stringから' do
        it '"39"を' do
          uri = Diva::Type::URI.cast("39")
          assert_equal '39', uri.to_s
          assert_kind_of Diva::URI, uri
          assert_nil uri.scheme
        end
        it '"abc"を' do
          uri = Diva::Type::URI.cast("abc")
          assert_equal 'abc', uri.to_s
          assert_kind_of Diva::URI, uri
          assert_nil uri.scheme
        end
        it '"http://mikutter.hachune.net/"を' do
          uri = Diva::Type::URI.cast("http://mikutter.hachune.net/")
          assert_equal 'http://mikutter.hachune.net/', uri.to_s
          assert_kind_of Diva::URI, uri
          assert_equal 'http', uri.scheme
        end
      end

      it 'Timeから' do
        time = Time.new(2009, 12, 25)
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::URI.cast(time)
        end
      end

      it 'URI::Genericから' do
        uri = URI.parse('http://mikutter.hachune.net/')
        assert_equal uri, Diva::Type::URI.cast(uri)
      end

      it 'Diva::URIから' do
        uri = Diva::URI.new('http://mikutter.hachune.net/')
        assert_equal uri, Diva::Type::URI.cast(uri)
      end

      it 'Addressable::URIから' do
        uri = Addressable::URI.parse('http://mikutter.hachune.net/')
        assert_equal uri, Diva::Type::URI.cast(uri)
      end

      it 'Modelから' do
        mk = Class.new(Diva::Model)
        mi = mk.new({})
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::URI.cast(mi)
        end
      end

      it '配列から' do
        assert_raises(Diva::InvalidTypeError) do
          Diva::Type::URI.cast(['156'])
        end
      end
    end
  end

  #
  # Model
  #
  describe 'Model' do
    before do
      @mk = Class.new(Diva::Model) do
        field.string :description
        field.string :name, required: true
        field.int :id, required: true
      end
      @constraint = Diva::Type.model_of(@mk)
    end

    it 'nameが"model"' do
      assert_equal :model, @constraint.name
    end

    describe 'キャスト' do
      it 'intから' do
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(39)
        end
      end

      it 'floatから' do
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(39.25)
        end
      end

      describe 'boolから' do
        it 'true' do
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast(true)
          end
        end
        it 'false' do
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast(false)
          end
        end
      end

      describe 'stringから' do
        it '"39"を' do
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast("39")
          end
        end
        it '"abc"を' do
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast("abc")
          end
        end
      end

      it 'Timeから' do
        time = Time.new(2009, 12, 25)
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(time)
        end
      end

      it 'URI::Genericから' do
        uri = URI.parse('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(uri)
        end
      end

      it 'Diva::URIから' do
        uri = Diva::URI.new('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(uri)
        end
      end

      it 'Addressable::URIから' do
        uri = Addressable::URI.parse('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(uri)
        end
      end

      describe 'Modelから' do
        it '正しいModel' do
          mi = @mk.new({name: '名前', id: 1})
          assert_equal mi, @constraint.cast(mi)
        end

        it 'Modelのサブクラス' do
          mi = Class.new(Diva::Model).new({})
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast(mi)
          end
        end
      end

      it '配列から' do
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(['156'])
        end
      end

      it 'Hashから' do
        result = @constraint.cast({name: "名前", id: '42', description: '詳細'})
        assert_instance_of @mk, result
        assert_equal '詳細', result.description
        assert_equal '名前', result.name
        assert_equal 42, result.id
      end
    end
  end

  #
  # Modelのサブクラス
  #
  describe 'Modelのサブクラス' do
    before do
      @mk = Class.new(Diva::Model)
      @constraint = Diva::Type.model_of(@mk)
    end

    it 'nameが"model"' do
      assert_equal :model, @constraint.name
    end

    describe 'キャスト' do
      it 'intから' do
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(39)
        end
      end

      it 'floatから' do
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(39.25)
        end
      end

      describe 'boolから' do
        it 'true' do
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast(true)
          end
        end
        it 'false' do
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast(false)
          end
        end
      end

      describe 'stringから' do
        it '"39"を' do
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast("39")
          end
        end
        it '"abc"を' do
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast("abc")
          end
        end
      end

      it 'Timeから' do
        time = Time.new(2009, 12, 25)
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(time)
        end
      end

      it 'URI::Genericから' do
        uri = URI.parse('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(uri)
        end
      end

      it 'Diva::URIから' do
        uri = Diva::URI.new('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(uri)
        end
      end

      it 'Addressable::URIから' do
        uri = Addressable::URI.parse('http://mikutter.hachune.net/')
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(uri)
        end
      end

      describe 'Modelから' do
        it '正しいModel' do
          mi = @mk.new({})
          assert_equal mi, @constraint.cast(mi)
        end

        it '想定していないModel' do
          mi = Class.new(Diva::Model).new({})
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast(mi)
          end
        end
      end

      it '配列から' do
        assert_raises(Diva::InvalidTypeError) do
          @constraint.cast(['156'])
        end
      end
    end
  end

  describe 'Array' do
    describe 'Stringの' do
      before do
        @constraint = Diva::Type.array_of(Diva::Type::STRING)
      end
      it 'nameが"string_array"' do
        assert_equal :string_array, @constraint.name
      end

      describe 'キャスト' do
        it 'intから' do
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast(39)
          end
        end

        it 'floatから' do
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast(39.25)
          end
        end

        describe 'boolから' do
          it 'true' do
            assert_raises(Diva::InvalidTypeError) do
              @constraint.cast(true)
            end
          end
          it 'false' do
            assert_raises(Diva::InvalidTypeError) do
              @constraint.cast(false)
            end
          end
        end

        describe 'stringから' do
          it '"39"を' do
            assert_raises(Diva::InvalidTypeError) do
              @constraint.cast("39")
            end
          end
          it '"abc"を' do
            assert_raises(Diva::InvalidTypeError) do
              @constraint.cast("abc")
            end
          end
        end

        it 'Timeから' do
          time = Time.new(2009, 12, 25)
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast(time)
          end
        end

        it 'URI::Genericから' do
          uri = URI.parse('http://mikutter.hachune.net/')
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast(uri)
          end
        end

        it 'Diva::URIから' do
          uri = Diva::URI.new('http://mikutter.hachune.net/')
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast(uri)
          end
        end

        it 'Addressable::URIから' do
          uri = Addressable::URI.parse('http://mikutter.hachune.net/')
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast(uri)
          end
        end

        it 'Modelから' do
          mk = Class.new(Diva::Model)
          mi = mk.new({})
          assert_raises(Diva::InvalidTypeError) do
            @constraint.cast(mi)
          end
        end

        describe '配列から' do
          it 'stringの配列' do
            expect = ['foo', 'bar']
            assert_equal expect, @constraint.cast(expect)
          end

          it '空の配列' do
            expect = []
            assert_equal expect, @constraint.cast(expect)
          end

          it 'intの配列' do
            expect = [1, 2]
            assert_equal ['1', '2'], @constraint.cast(expect)
          end

          it 'Modelの配列' do
            mk = Class.new(Diva::Model)
            expect = [mk.new({}), mk.new({})]
            assert_raises(Diva::InvalidTypeError) do
              @constraint.cast(expect)
            end
          end
        end
      end
    end

    describe 'Modelの' do
      before do
        @mc = Class.new(Diva::Model)
        @constraint = Diva::Type.array_of(@mc)
      end

      describe '配列から' do
        it 'Modelの配列' do
          expect = [@mc.new({})]
          assert_equal expect, @constraint.cast(expect)
        end
      end

    end

  end

end
