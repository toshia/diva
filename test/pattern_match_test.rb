# frozen_string_literal: true

require_relative 'test_helper'

describe 'Pattern Match' do
  describe 'Flat model' do
    before do
      @mk = Class.new(Diva::Model) do
        field.int :id, required: true
        field.string :title, required: true
        field.string :category, required: true
      end
      @mi = @mk.new(id: 1, title: 'article title 1', category: 'news')
    end

    it 'match' do
      detect = nil
      case @mi
      in category: 'news', title: String => title
        detect = title
      end
      assert_equal 'article title 1', detect
    end

    it 'does not match' do
      detect = false
      case @mi
      in category: 'diary', title: String => title
        refute 'Unexpectedly matched'
      else
        detect = true
      end
      assert detect, 'It should not match'
    end

    it 'undefined key' do
      detect = false
      case @mi
      in tag: Array, title: String => title
        refute 'Unexpectedly matched'
      else
        detect = true
      end
      assert detect, 'It should not match'
    end

    it 'rest' do
      detect = false
      case @mi
      in **rest
        detect = rest
      end
      assert_equal @mi.to_h, detect
    end
  end

  describe 'Hierarchycal' do
    before do
      @mk = Class.new(Diva::Model) do
        field.int :id, required: true
        field.string :body, required: true
      end
      @mk.add_field(:to, type: @mk, required: true)
    end

    describe 'direct instance bind' do
      before do
        @mi = @mk.new(id: 1, body: 'text 1')
        @mi2 = @mk.new(id: 2, body: 'reply 1', to: @mi)
        @mi3 = @mk.new(id: 3, body: 'reply 2', to: @mi2)
      end

      it 'match' do
        detect = nil
        case @mi3
        in { to: { to: {id: 1} } } => target
          detect = target
        end
        assert_equal @mi3, detect
      end
    end

    describe 'static' do
      before do
        @mi3 = @mk.new(id: 3, body: 'reply 2', to: {
                         id: 2, body: 'reply 1', to: {
                           id: 1, body: 'text 1'
                         }
                       })
      end

      it 'match' do
        detect = nil
        case @mi3
        in { to: { to: {id: 1} => target } }
          detect = target
        end
        assert_equal 'text 1', detect.body
      end
    end
  end
end
