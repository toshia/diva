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
require 'time'
require 'diva/uri'

module Diva::Type
  extend self

  def model_of(model)
    ModelType.new(model)
  end

  def array_of(type)
    ArrayType.new(type)
  end

  def optional(type)
    UnionType.new(NULL, type)
  end

  def union(*types)
    UnionType.new(*types)
  end

  # 全てのType共通のスーパークラス
  class MetaType
    attr_reader :name

    def initialize(name, *, &cast)
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

    def dump_for_json(value)
      value
    end

    def inspect
      "Diva::Type(#{self})"
    end
  end

  class AtomicType < MetaType
    def initialize(name, recommended_class, *rest, &cast)
      super(name, *rest, &cast)
      @recommended_classes = Array(recommended_class)
    end

    def recommendation_point(value)
      _, point = @recommended_classes.map.with_index { |k, i| [k, i] }.find { |k, _| value.is_a?(k) }
      point
    end

    def schema
      @schema ||= { type: uri }.freeze
    end

    def uri
      @uri ||= Diva::URI("diva://atomic.type/#{name}")
    end
  end

  INT = AtomicType.new(:int, [Integer]) do |v|
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
  FLOAT = AtomicType.new(:float, [Float]) do |v|
    case v
    when Float
      v
    when Numeric, String, Time
      v.to_f
    else
      raise Diva::InvalidTypeError, "The value is not a `#{name}'."
    end
  end
  BOOL = AtomicType.new(:bool, [TrueClass, FalseClass]) do |v|
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
  STRING = AtomicType.new(:string, String) do |v|
    case v
    when Diva::Model, Enumerable
      raise Diva::InvalidTypeError, "The value is not a `#{name}'."
    else
      v.to_s
    end
  end
  class TimeType < AtomicType
    def dump_for_json(value)
      cast(value).iso8601
    end
  end
  TIME = TimeType.new(:time, [Time, String]) do |v|
    case v
    when Time
      v
    when Integer, Float
      Time.at(v)
    when String
      Time.iso8601(v)
    else
      raise Diva::InvalidTypeError, "The value is not a `#{name}'."
    end
  end
  URI = AtomicType.new(:uri, [Diva::URI, Addressable::URI, ::URI::Generic]) do |v|
    case v
    when Diva::URI, Addressable::URI, ::URI::Generic
      v
    when String
      Diva::URI.new(v)
    else
      raise Diva::InvalidTypeError, "The value is not a `#{name}'."
    end
  end
  NULL = AtomicType.new(:null, NilClass) do |v|
    if v == nil
      v
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

    def recommendation_point(v)
      v.is_a?(model) && 0
    end

    def cast(value)
      case value
      when model
        value
      when Hash
        model.new(value)
      else
        raise Diva::InvalidTypeError, "The value #{value.inspect} is not a `#{model}'."
      end
    end

    def schema
      @schema ||= { type: uri }.freeze
    end

    def to_s
      "#{model} #{name}"
    end

    def uri
      model.uri
    end
  end

  class ArrayType < MetaType
    def initialize(type)
      type = Diva::Type(type)
      super("#{type.name}_array")
      @type = type
    end

    def recommendation_point(values)
      values.is_a?(Enumerable) && values.all? { |v| @type.recommendation_point(v) } && 0
    end

    def cast(value)
      raise Diva::InvalidTypeError, "The value is not a `#{name}'." unless value.is_a?(Enumerable)
      value.to_a.map(&@type.method(:cast))
    end

    def dump_for_json(value)
      value.to_a.map(&@type.method(:dump_for_json))
    end

    def to_s
      "Array of #{@type}"
    end

    def schema
      @schema ||= { array: @type.schema }.freeze
    end
  end

  class UnionType < MetaType
    def initialize(*types)
      @types = types.flatten.map(&Diva.method(:Type)).freeze
      super("union_#{@types.map(&:name).join('_')}")
    end

    def recommendation_point(v)
      @types.map { |t| t.recommendation_point(v) }.compact.min
    end

    def cast(value)
      recommended_type_of(value).cast(value)
    end

    def dump_for_json(value)
      recommended_type_of(value).dump_for_json(value)
    end

    def to_s
      @types.map(&:name).join('|').freeze
    end

    def schema
      @schema ||= { union: @types.map(&:schema) }.freeze
    end

    def recommended_type_of(value)
      @types.map { |t|
        [t, t.recommendation_point(value)]
      }.select { |_, p| p }.sort_by { |_, p| p }.each do |t, _|
        return t
      end
      @types.each do |type|
        type.cast(value)
        return type
      rescue Diva::InvalidTypeError
        # try next
      end
      raise Diva::InvalidTypeError, "The value is not #{self}"
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
    when :null
      Diva::Type::NULL
    when ->(x) { x.instance_of?(Class) && x.ancestors.include?(Diva::Model) }
      Diva::Type.model_of(type)
    when Array
      if type.size >= 2
        Diva::Type.union(*type)
      else
        Diva::Type.array_of(type.first)
      end
    else
      fail "Invalid type #{type.inspect} (#{type.class})."
    end
  end
end
