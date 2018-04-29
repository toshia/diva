# coding: utf-8
require 'diva/version'
require 'diva/datasource'
require 'diva/error'
require 'diva/field_generator'
require 'diva/field'
require 'diva/model'
require 'diva/spec'
require 'diva/type'
require 'diva/uri'
require 'diva/version'


module Diva
  def self.URI(uri)
    Diva::URI.new(uri)
  end
end
