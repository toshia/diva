# -*- coding: utf-8 -*-
=begin rdoc
  いろんなリソースの基底クラス
=end

require 'diva/combinator'
require 'diva/model_extend'
require 'diva/uri'
require 'diva/spec'

require 'securerandom'

class Diva::Model
  include Comparable
  include Diva::Combinable
  extend Diva::ModelExtend

  def initialize(args)
    @value = args.dup
    validate
    self.class.store_datum(self)
  end

  # データをマージする。
  # selfにあってotherにもあるカラムはotherの内容で上書きされる。
  # 上書き後、データはDataSourceに保存される
  def merge(other)
    @value.update(other.to_hash)
    validate
    self.class.store_datum(self)
  end

  # このModelのパーマリンクを返す。
  # パーマリンクはWebのURLで、Web上のリソースでない場合はnilを返す。
  # ==== Return
  # 次のいずれか
  # [URI::HTTP|Diva::URI] パーマリンク
  # [nil] パーマリンクが存在しない
  def perma_link
    nil
  end

  # このModelのURIを返す。
  # ==== Return
  # [URI::Generic|Diva::URI] パーマリンク
  def uri
    perma_link || Diva::URI.new("#{self.class.scheme}://#{self.class.host}#{path}")
  end

  # このModelが、登録されているアカウントのうちいずれかが作成したものであれば true を返す
  # ==== Args
  # [service] Service | Enumerable 「自分」のService
  # ==== Return
  # [true] 自分のによって作られたオブジェクトである
  # [false] 自分のによって作られたオブジェクトではない
  def me?(service=nil)
    false
  end

  def hash
    @_hash ||= self.uri.to_s.hash ^ self.class.hash
  end

  def <=>(other)
    if other.is_a?(Diva::Model)
      created - other.created
    elsif other.respond_to?(:[]) and other[:created]
      created - other[:created]
    else
      id - other
    end
  end

  def ==(other)
    if other.is_a? Diva::Model
      self.class == other.class && uri == other.uri
    end
  end

  def eql?(other)
    self == other
  end

  def to_hash
    Hash[self.class.fields.map{|f| [f.name, fetch(f.name)] }]
  end

  def to_json(*rest, **kwrest)
    to_hash.to_json(*rest, **kwrest)
  end

  # カラムの生の内容を返す
  def fetch(key)
    @value[key.to_sym]
  end
  alias [] fetch

  # カラムに別の値を格納する。
  # 格納後、データはDataSourceに保存される
  def []=(key, value)
    @value[key.to_sym] = value
    self.class.store_datum(self)
    value
  end

  # カラムと型が違うものがある場合、例外を発生させる。
  def validate
    raise RuntimeError, "argument is #{@value}, not Hash" if not @value.is_a?(Hash)
    self.class.fields.each do |field|
      begin
        @value[field.name] = field.type.cast(@value[field.name])
      rescue Diva::InvalidTypeError => err
        raise Diva::InvalidTypeError, "#{err} in field `#{field}'"
      end
    end
  end

  # キーとして定義されていない値を全て除外した配列を生成して返す。
  # また、Modelを子に含んでいる場合、それを外部キーに変換する。
  def filtering
    datum = self.to_hash
    result = Hash.new
    self.class.fields.each do |field|
      begin
        result[field.name] = field.type.cast(datum[field.name])
      rescue Diva::InvalidTypeError => err
        raise Diva::InvalidTypeError, "#{err} in field `#{field}'"
      end
    end
    result
  end

  # このインスタンスのタイトル。
  def title
    fields = self.class.fields.lazy.map(&:name)
    case
    when fields.include?(:name)
      name.gsub("\n", '')
    when fields.include?(:description)
      description.gsub("\n", '')
    else
      to_s.gsub("\n", '')
    end
  end

  private
  # URIがデフォルトで使うpath要素
  def path
    @path ||= "/#{SecureRandom.uuid}"
  end

end

