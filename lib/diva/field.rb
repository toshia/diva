# -*- coding: utf-8 -*-

require 'diva/type'

=begin rdoc
Modelのキーの情報を格納する。
キーひとつにつき1つのインスタンスが作られる。
=end
module Diva
  class Field
    attr_reader :name, :type, :required

    # [name] Symbol フィールドの名前
    # [type] Symbol フィールドのタイプ。:int, :string, :bool, :time のほか、Diva::Modelのサブクラスを指定する
    # [required] boolean _true_ なら、この項目を必須とする
    def initialize(name, type, required: false)
      @name = name.to_sym
      @type = Diva::Type.optional(Diva::Type(type))
      @required = !!required
    end

    def dump_for_json(value)
      type.dump_for_json(value)
    end

    def required?
      required
    end

    def to_sym
      name
    end

    def to_s
      name.to_s
    end

    def inspect
      "#<#{self.class}: #{name}(#{type})#{required ? '*' : ''}>"
    end
  end
end
