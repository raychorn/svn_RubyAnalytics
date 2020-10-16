require 'rubygems'
require 'test/unit'
require 'mocha'

ENV['RAILS_ENV'] = 'test'

require 'active_support'
require 'active_support/all' unless Class.respond_to?(:cattr_accessor)
require 'rails-footnotes/footnotes'
require 'rails-footnotes/notes/abstract_note'
require "rails-footnotes"
