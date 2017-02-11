# -*- coding: utf-8 -*-
module Diva
  class DivaError < StandardError; end

  class InvalidTypeError < DivaError; end

  class InvalidEntityError < DivaError; end

  # 実装してもしなくてもいいメソッドが実装されておらず、結果を得られない
  class NotImplementedError < DivaError; end

  # IDやURIなどの一意にリソースを特定する情報を使ってデータソースに問い合わせたが、
  # 対応する情報が見つからず、Modelを作成できない
  class ModelNotFoundError < DivaError; end

  # URIとして受け付けられない値を渡された
  class InvalidURIError < InvalidTypeError; end

end
