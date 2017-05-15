# -*- coding: utf-8 -*-

module Diva::Combinable
  class Combinator
    def initialize(a, b)
      @a, @b = a, b
    end

    # コンストラクタに渡された二つの値が _behavior_ をサポートしていれば真を返す
    # ==== Args
    # [behavior] 想定する振る舞い(Symbol)
    # ==== Return
    # true or false
    def =~(behavior)
      fail 'Not implement'
    end

    def ===(behavior)
      self =~ behavior
    end

    # このCombinatorが持っている値のすべての組み合わせのうち、適切に _behavior_
    # をサポートしている組み合わせについて繰り返すEnumeratorを返す
    # ==== Args
    # [behavior] 想定する振る舞い(Symbol)
    # ==== Return
    # [レシーバ, 引数] のペアを列挙するEnumerator
    def enum(behavior)
      Enumerator.new do |yielder|
        yielder << [@a, @b] if a_b(behavior)
        yielder << [@b, @a] if b_a(behavior)
      end
    end

    def method_missing(behavior, *rest)
      if rest.empty?
        return self =~ behavior
      end
      super
    end

    private

    def a_b(behavior)
      @a.respond_to?(behavior) && @a.__send__(behavior, @b)
    end

    def b_a(behavior)
      @b.respond_to?(behavior) && @b.__send__(behavior, @a)
    end
  end

  class PluralCombinator < Combinator
    def enum(behavior)
      Enumerator.new do |yielder|
        @b.each do |b|
          (b | @a).enum(behavior).each(&yielder.method(:<<))
        end
      end
    end
  end

  class SingleCombinator < Combinator
    def =~(behavior)
      a_b(behavior) || b_a(behavior)
    end
  end

  class AnyCombinator < PluralCombinator
    def =~(behavior)
      @b.any?{|b| b | @a =~ behavior }
    end
  end

  class AllCombinator < PluralCombinator
    def =~(behavior)
      @b.all?{|b| b | @a =~ behavior }
    end
  end

  # _other_ との Diva::Conbinable::Combinator を生成する
  # ==== Args
  # [other] Diva::Modelか、Diva::Modelを列挙するEnumerable
  # ==== Return
  # Diva::Conbinable::Combinator
  def |(other)
    if other.is_a? Enumerable
      AnyCombinator.new(self, other)
    else
      SingleCombinator.new(self, other)
    end
  end

  # _other_ との Diva::Conbinable::Combinator を生成する
  # ==== Args
  # [other] Diva::Modelか、Diva::Modelを列挙するEnumerable
  # ==== Return
  # Diva::Conbinable::Combinator
  def &(other)
    if other.is_a? Enumerable
      AllCombinator.new(self, other)
    else
      SingleCombinator.new(self, other)
    end
  end
end
