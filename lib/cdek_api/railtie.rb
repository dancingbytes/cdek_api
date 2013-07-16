# encoding: utf-8
require 'rails/railtie'

module CdekApi

  class Railtie < ::Rails::Railtie #:nodoc:

    rake_tasks do
      load File.expand_path('../../tasks/cdek.rake', __FILE__)
    end

  end # Railtie

end # CdekApi
