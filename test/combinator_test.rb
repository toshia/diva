# -*- coding: utf-8 -*-

require_relative 'test_helper'

describe 'Combonator' do
  before do
    @mku = mku = Class.new(Diva::Model) do
      def self.slug; :user end
      def self.to_s; "#<#{slug} model>" end
      def repliable?(w)
        w.class.slug == :account
      end

      def followable?(w)
        w.class.slug == :account
      end
    end
    @mka = Class.new(Diva::Model) do
      def self.slug; :account end
      def self.to_s; "#<#{slug} model>" end

      field.has :user, mku, required: true

      def repliable?(w)
        %i<user message>.include? w.class.slug
      end

      def favoritable?(w)
        w.class.slug == :message
      end

      def followable?(w)
        w.class.slug == :user
      end

      def deletable?(w)
        w.class.slug == :post && w.user == user
      end
    end
    @mkp = Class.new(Diva::Model) do
      def self.slug; :post end
      def self.to_s; "#<#{slug} model>" end

      field.has :user, mku, required: true

      def repliable?(w)
        w.class.slug == :account
      end

      def favoritable?(w)
        w.class.slug == :account
      end

      def deletable?(w)
        w.class.slug == :account && w.user == user
      end
    end
  end

  describe 'basic condition' do
    before do
      @iu = @mku.new({})
      @ia = @mka.new(user: @iu)
      @ip = @mkp.new(user: @iu)
    end

    it 'can reply account to post' do
      assert_match :repliable?, @ia | @ip
      assert (@ia | @ip).repliable?
    end

    it 'can reply account to user' do
      assert_match :repliable?, @ia | @iu
      assert (@ia | @iu).repliable?
    end

    it 'can\'t reply user to post' do
      refute_match :repliable?, @iu | @ip
      refute (@iu | @ip).repliable?
    end
  end

  describe 'undefined condition' do
    before do
      @iu = @mku.new({})
      @ia = @mka.new(user: @iu)
      @ip = @mkp.new(user: @iu)
    end

    it 'can add favorite account to post' do
      assert_match :favoritable?, @ia | @ip
    end

    it 'can\'t add favorite account to user' do
      refute_match :favoritable?, @ia | @iu
    end

    it 'can\'t add favorite user to post' do
      refute_match :favoritable?, @iu | @ip
    end
  end

  describe 'many object' do
    before do
      @iua = @mku.new({})
      @iub = @mku.new({})
      @ipa = 2.times.map{ @mkp.new(user: @iua) }
      @ipb = 3.times.map{ @mkp.new(user: @iub) }
      @ipmixed = @ipa + @ipb
      @iaa = @mka.new(user: @iua)
    end

    it 'can delete my post' do
      assert_includes (@iaa | @ipa).enum(:deletable?), [@ipa[0], @iaa]
      assert_includes (@iaa | @ipa).enum(:deletable?), [@iaa, @ipa[0]]
      assert_includes (@iaa | @ipa).enum(:deletable?), [@ipa[1], @iaa]
      assert_includes (@iaa | @ipa).enum(:deletable?), [@iaa, @ipa[1]]
    end

    it 'should return true all posts are deletable' do
      assert_match :deletable?, (@iaa | @ipa)
      assert_match :deletable?, (@iaa & @ipa)
      refute_match :deletable?, (@iaa | @ipb)
      refute_match :deletable?, (@iaa & @ipb)
      assert_match :deletable?, (@iaa | @ipmixed), 'it should return true some posts are myself.'
      refute_match :deletable?, (@iaa & @ipmixed), 'it should return false some posts aren\'t myself.'
    end

    it 'can\'t delete other post' do
      assert_empty (@iaa | @ipb).enum(:deletable?).to_a
      refute_match :deletable?, (@iaa | @ipb)
      refute_match :deletable?, (@iaa & @ipb)
    end
  end
end
