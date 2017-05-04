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
      @a.respond_to?(behavior) && @a.__send__(behavior, @b) || @b.respond_to?(behavior) && @b.__send__(behavior, @a)
    end
    alias_method :===, :=~

    # このCombinatorが持っている値のすべての組み合わせのうち、適切に _behavior_
    # をサポートしている組み合わせについて繰り返すEnumeratorを返す
    # ==== Args
    # [behavior] 想定する振る舞い(Symbol)
    # ==== Return
    # [レシーバ, 引数] のペアを列挙するEnumerator
    def enum(behavior)
      Enumerator.new do |yielder|
        yielder << [@a, @b] if @a.respond_to?(behavior) && @a.__send__(behavior, @b)
        yielder << [@b, @a] if @b.respond_to?(behavior) && @b.__send__(behavior, @a)
      end
    end

    def method_missing(behavior, *rest)
      if rest.empty?
        return self =~ behavior
      end
      super
    end
  end

  class EnumerableCombinator < Combinator
    def =~(behavior)
      @b.any?{|b| !enum(behavior).empty? }
    end

    def enum(behavior)
      Enumerator.new do |yielder|
        @b.each do |b|
          (@a | b).enum(behavior).each(&yielder.method(:<<))
        end
      end
    end
  end

  # _other_ との Diva::Conbinable::Combinator を生成する
  # ==== Args
  # [other] Diva::Modelか、Diva::Modelを列挙するEnumerable
  # ==== Return
  # Diva::Conbinable::Combinator
  def |(other)
    if other.is_a? Enumerable
      EnumerableCombinator.new(self, other)
    else
      Combinator.new(self, other)
    end
  end
end
