# -*- coding: utf-8 -*-

=begin rdoc
Modelの各キーに格納できる値の制約。
この制約に満たない場合は、アトミックな制約であれば値の変換が行われ、そうでない場合は
Diva::InvalidTypeError 例外を投げる。

これは新しくインスタンスなどを作らず、INT、FLOATなどのプリセットを利用する。

== 設定できる制約
Modelフィールドの制約には以下のようなものがある。

=== アトミックな制約
以下のような値は、DivaのModelフィールドにおいてはアトミックな制約と呼び、そのまま格納できる。
[INT] 数値(Integer)
[FLOAT] 少数(Float)
[BOOL] 真理値(true|false)
[STRING] 文字列(String)
[TIME] 時刻(Time)
[URI] URI(Diva::URI|URI::Generic|Addressable::URI)

=== Model
Diva::Modelのサブクラスであれば、それを制約とすることができる。

=== 配列
アトミックな制約またはModel制約を満たした値の配列を格納することができる。
配列の全ての要素が設定された制約を満たしていれば、配列制約が満たされたことになる。

=end
module Diva::Type
  extend self

  def model_of(model)
    ModelType.new(model)
  end

  def array_of(type)
    ArrayType.new(type)
  end

  def optional(type)
    OptionalType.new(type)
  end

  # 全てのType共通のスーパークラス
  class MetaType
    attr_reader :name

    def initialize(name, *rest, &cast)
      @name = name.to_sym
      if cast
        define_singleton_method :cast, &cast
      end
    end

    def cast(value)
      value
    end

    def to_s
      name.to_s
    end

    def inspect
      "Diva::Type(#{to_s})"
    end
  end

  class AtomicType < MetaType
  end

  INT = AtomicType.new(:int) do |v|
    case v
    when Integer
      v
    when Numeric, String, Time
      v.to_i
    when TrueClass
      1
    when FalseClass
      0
    else
      raise Diva::InvalidTypeError, "The value is not a `#{name}'."
    end
  end
  FLOAT = AtomicType.new(:float) do |v|
    case v
    when Float
      v
    when Numeric, String, Time
      v.to_f
    else
      raise Diva::InvalidTypeError, "The value is not a `#{name}'."
    end
  end
  BOOL = AtomicType.new(:bool) do |v|
    case v
    when TrueClass, FalseClass
      v
    when String
      !v.empty?
    when Integer
      v != 0
    else
      raise Diva::InvalidTypeError, "The value is not a `#{name}'."
    end
  end
  STRING = AtomicType.new(:string) do |v|
    case v
    when Diva::Model, Enumerable
      raise Diva::InvalidTypeError, "The value is not a `#{name}'."
    else
      v.to_s
    end
  end
  TIME = AtomicType.new(:time) do |v|
    case v
    when Time
      v
    when Integer, Float
      Time.at(v)
    when String
      Time.new(v)
    else
      raise Diva::InvalidTypeError, "The value is not a `#{name}'."
    end
  end
  URI = AtomicType.new(:uri) do |v|
    case v
    when Diva::URI, Addressable::URI, ::URI::Generic
      v
    when String
      Diva::URI.new(v)
    else
      raise Diva::InvalidTypeError, "The value is not a `#{name}'."
    end
  end

  class ModelType < MetaType
    attr_reader :model
    def initialize(model, *rest, &cast)
      super(:model, *rest)
      @model = model
    end

    def cast(value)
      raise Diva::InvalidTypeError, "The value is not a `#{model}'." unless value.is_a?(model)
      value
    end

    def to_s
      "#{model} #{name}"
    end
  end

  class ArrayType < MetaType
    def initialize(type)
      type = Diva::Type(type)
      super("#{type.name}_array")
      @type = type
    end

    def cast(value)
      raise Diva::InvalidTypeError, "The value is not a `#{name}'." unless value.is_a?(Enumerable)
      value.to_a.map(&@type.method(:cast))
    end

    def to_s
      "Array of #{@type.to_s}"
    end
  end

  class OptionalType < MetaType
    def initialize(type)
      super("optional_#{type.name}")
      @type = type
    end

    def cast(value)
      if value.nil?
        value
      else
        @type.cast(value)
      end
    end

    def to_s
      "#{@type.to_s}|nil"
    end
  end

end

module Diva
  def self.Type(type)
    case type
    when Diva::Type::MetaType
      type
    when :int
      Diva::Type::INT
    when :float
      Diva::Type::FLOAT
    when :bool
      Diva::Type::BOOL
    when :string
      Diva::Type::STRING
    when :time
      Diva::Type::TIME
    when :uri
      Diva::Type::URI
    when ->x{x.class == Class && x.ancestors.include?(Diva::Model) }
      Diva::Type.model_of(type)
    when Array
      Diva::Type.array_of(type.first)
    else
      fail "Invalid type #{type.inspect} (#{type.class})."
    end
  end
end
