# -*- coding: utf-8 -*-

require 'diva/field'
require 'diva/type'

=begin rdoc
Diva::Model のクラスメソッド
=end
module Diva::ModelExtend
  extend Gem::Deprecate

  attr_reader :slug, :spec

  # Modelのインスタンスのuriスキーム。オーバライドして適切な値にする
  # ==== Return
  # [String] URIスキーム
  def scheme
    @_scheme ||= self.to_s.split('::',2).first.gsub(/\W/,'').downcase.freeze
  end

  # Modelのインスタンスのホスト名。オーバライドして適切な値にする
  # ==== Return
  # [String] ホスト名
  def host
    @_host ||= self.to_s.split('::',2).last.split('::').reverse.join('.').gsub(/[^\w\.]/,'').downcase.freeze
  end

  # Modelにフィールドを追加する。
  # ==== Args
  # [field_name] Symbol フィールドの名前
  # [type] Symbol フィールドのタイプ。:int, :string, :bool, :time のほか、Diva::Modelのサブクラスを指定する
  # [required] boolean _true_ なら、この項目を必須とする
  def add_field(field, type: nil, required: false)
    if field.is_a?(Symbol)
      field = Diva::Field.new(field, type, required: required)
    end
    (@fields ||= []) << field
    define_method(field.name) do
      @value[field.name]
    end

    define_method("#{field.name}?") do
      !!@value[field.name]
    end

    define_method("#{field.name}=") do |value|
      @value[field.name] = field.type.cast(value)
      self.class.store_datum(self)
      value
    end
    self
  end

  def fields
    @fields ||= []
  end
  alias :keys :fields
  deprecate :keys, "fields", 2018, 02

  def schema
    {
      fields: fields.map(&:schema),
      uri: uri
    }
  end

  def uri
    @uri ||= Diva::URI("diva://object.type/#{slug || SecureRandom.uuid}")
  end

  #
  # プライベートクラスメソッド
  #

  def field
    Diva::FieldGenerator.new(self)
  end

  # URIに対応するリソースの内容を持ったModelを作成する。
  # URIに対応する情報はネットワーク上などから取得される場合もある。そういった場合はこのメソッドは
  # Delayer::Deferred::Deferredable を返す可能性がある。
  # とくにオーバライドしない場合、このメソッドは常に例外 Diva::NotImplementedError を投げる。
  # ==== Args
  # [uri] _handle_ メソッドで指定したいずれかの条件に一致するURI
  # ==== Return
  # [Delayer::Deferred::Deferredable]
  #   ネットワークアクセスを行って取得するなど取得に時間がかかる場合
  # [self]
  #   すぐにModelを生成できる場合、そのModel
  # ==== Raise
  # [Diva::NotImplementedError]
  #   このModelでは、find_by_uriが実装されていない
  # [Diva::ModelNotFoundError]
  #   _uri_ に対応するリソースが見つからなかった
  def find_by_uri(uri)
    raise Diva::NotImplementedError, "#{self}.find_by_uri does not implement."
  end

  # Modelが生成・更新された時に呼ばれるコールバックメソッドです
  def store_datum(retriever); end

  def container_class
    Array
  end
end
