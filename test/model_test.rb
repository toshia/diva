# -*- coding: utf-8 -*-

require_relative 'test_helper'

describe 'Model' do
  before do
    @mk = Class.new(Diva::Model)
  end

  describe 'Field' do
    describe 'atomic type' do
      before do
        @mk.add_field(:field_0, type: :int)
        @mi = @mk.new(field_0: 1)
      end

      it 'Accessorの定義' do
        assert_respond_to @mi, :field_0, 'Reader does not defined.'
        assert_respond_to @mi, :field_0?, 'Reader does not defined.'
        assert_respond_to @mi, :field_0=, 'Writer does not defined.'
      end

      it '値を読み取る' do
        assert_equal 1, @mi.field_0
      end

      it '値の存在確認をする' do
        assert @mi.field_0?, 'field_0は真値なので#field_0?はtrueを返す'
      end

      describe '値を更新する' do
        it '39 へ更新すると、そのまま39が格納される' do
          @mi.field_0 = 39
          assert_equal 39, @mi.field_0
        end

        it '39.25 へ更新すると、to_iされた値が格納される' do
          @mi.field_0 = 39.25
          assert_equal 39.25.to_i, @mi.field_0
        end

        it '"39" へ更新すると、to_iされた値が格納される' do
          @mi.field_0 = "39"
          assert_equal "39".to_i, @mi.field_0
        end

        it '"abc" へ更新すると、to_iされた値が格納される' do
          @mi.field_0 = "abc"
          assert_equal "abc".to_i, @mi.field_0
        end

        it 'Time へ更新すると、 Diva::InvalidTypeError 例外を投げる' do
          time = Time.new(2009, 12, 25)
          @mi.field_0 = time
          assert_equal time.to_i, @mi.field_0
        end

        it 'Model へ更新しようとすると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            @mi.field_0 = @mk.new(field_0: 42)
          end
        end

        it '[39, 42] (intの配列) へ更新しようとすると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            @mi.field_0 = [39, 42]
          end
        end
      end

      it 'inspect' do
        assert_instance_of String, @mk.fields.inspect
      end

    end

    describe 'model type (subclass)' do
      before do
        @child_k = Class.new(Diva::Model)
        @child = @child_k.new({})
        @mk.add_field(:child, type: @child_k)
        @mi = @mk.new(child: @child)
      end

      it 'Accessorの定義' do
        assert_respond_to @mi, :child, 'Reader does not defined.'
        assert_respond_to @mi, :child?, 'Reader does not defined.'
        assert_respond_to @mi, :child=, 'Writer does not defined.'
      end

      it '値を読み取る' do
        assert_equal @child, @mi.child
      end

      it '値の存在確認をする' do
        assert @mi.child?, 'childは真値なので#child?はtrueを返す'
      end

      describe '値を更新する' do
        it '39 へ更新すると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            @mi.child = 39
          end
        end

        it '39.25 へ更新すると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            @mi.child = 39.25
          end
        end

        it '"39" へ更新すると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            @mi.child = "39"
          end
        end

        it '"abc" へ更新すると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            @mi.child = "abc"
          end
        end

        it 'Time へ更新すると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            time = Time.new(2009, 12, 25)
            @mi.child = time
          end
        end

        it 'Model へ更新しようとすると、そのインスタンスがそのまま格納される' do
          newval = @child_k.new({})
          mi2 = @mk.new(child: newval)
          assert_equal newval, mi2.child
        end

        it '[39, 42] (intの配列) へ更新しようとすると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            @mi.child = [39, 42]
          end
        end

        it 'Modelの配列へ更新しようとすると、 Diva::InvalidTypeError 例外を投げる' do
          mc = @mk.new(child: nil)
          assert_raises(Diva::InvalidTypeError) do
            @mi.child = [mc]
          end
        end
      end
    end

    describe 'model type' do
      before do
        @child_k = Class.new(Diva::Model)
        @child = @child_k.new({})
        @mk.add_field(:child, type: Diva::Model)
        @mi = @mk.new(child: @child)
      end

      it 'Accessorの定義' do
        assert_respond_to @mi, :child, 'Reader does not defined.'
        assert_respond_to @mi, :child?, 'Reader does not defined.'
        assert_respond_to @mi, :child=, 'Writer does not defined.'
      end

      it '値を読み取る' do
        assert_equal @child, @mi.child
      end

      it '値の存在確認をする' do
        assert @mi.child?, 'childは真値なので#child?はtrueを返す'
      end

      describe '値を更新する' do
        it '39 へ更新すると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            @mi.child = 39
          end
        end

        it '39.25 へ更新すると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            @mi.child = 39.25
          end
        end

        it '"39" へ更新すると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            @mi.child = "39"
          end
        end

        it '"abc" へ更新すると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            @mi.child = "abc"
          end
        end

        it 'Time へ更新すると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            time = Time.new(2009, 12, 25)
            @mi.child = time
          end
        end

        it 'Model へ更新しようとすると、そのインスタンスがそのまま格納される' do
          newval = @child_k.new({})
          mi2 = @mk.new(child: newval)
          assert_equal newval, mi2.child
        end

        it '[39, 42] (intの配列) へ更新しようとすると、 Diva::InvalidTypeError 例外を投げる' do
          assert_raises(Diva::InvalidTypeError) do
            @mi.child = [39, 42]
          end
        end

        it 'Modelの配列へ更新しようとすると、 Diva::InvalidTypeError 例外を投げる' do
          mc = @mk.new(child: nil)
          assert_raises(Diva::InvalidTypeError) do
            @mi.child = [mc]
          end
        end
      end
    end

  end

  describe 'URI' do
    it 'とくに定義のないModelでもURIを取得できる' do
      mi = @mk.new({})
      assert_instance_of Diva::URI, mi.uri
    end
  end

  describe 'dig' do
    before do
      @mk.add_field(:field_0, type: :string)
    end

    it '存在しないフィールドを取得' do
      @mi = @mk.new({})
      assert_nil @mi.dig('foobar')
    end

    it 'Symbolに変換できないフィールドを取得' do
      refute 0.respond_to?(:to_sym), 'Integer#to_symが実装されているためテストにならない'
      @mi = @mk.new({})
      assert_nil @mi.dig(0)
    end

    it '存在するフィールドを取得' do
      value = SecureRandom.uuid
      @mi = @mk.new(field_0: value)
      assert_equal value, @mi.dig('field_0')
    end

    describe 'Arrayを含むキー' do
      before do
        @mk.add_field(:field_1, type: [:string])
        @mi = @mk.new(field_1: ['a', 'b', 'c'])
      end

      it '存在しない要素を取得' do
        assert_nil @mi.dig('field_1', 100)
      end

      it '存在する要素を取得' do
        assert_equal 'a', @mi.dig('field_1', 0)
        assert_equal 'b', @mi.dig('field_1', 1)
        assert_equal 'c', @mi.dig('field_1', 2)
      end
    end

    describe 'Modelを含むArray' do
      before do
        @mi_list = [@mk.new(field_0: 'a'), @mk.new(field_0: 'b'), @mk.new(field_0: 'c')]
      end

      it '存在しない要素を取得' do
        assert_nil @mi_list.dig(0, 'foobar')
      end

      it '存在する要素を取得' do
        assert_equal 'a', @mi_list.dig(0, 'field_0')
        assert_equal 'b', @mi_list.dig(1, 'field_0')
        assert_equal 'c', @mi_list.dig(2, 'field_0')
      end
    end

  end
end
