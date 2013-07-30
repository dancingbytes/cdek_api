# encoding: utf-8
require 'net/http'
require 'digest/md5'
require 'nokogiri'

require "cdek_api/version"
require "cdek_api/ext"
require 'cdek_api/mailer'

require "cdek_api/cities"

require "cdek_api/delivery"

require "cdek_api/errors"
require "cdek_api/calculator_errors"

require "cdek_api/respond"
require "cdek_api/base"
require "cdek_api/calculator"

module Cdek

  extend self

  HOST          = 'gw.edostavka.ru'
  PORT          = 11443
  USE_SSL       = false
  RETRY         = 5
  WAIT_TIME     = (defined?(::Rake) ? 10 : 5)
  UUID          = "51ee154e8a67ade33b00000a".freeze

  DATE_FORMAT   = "%Y-%m-%dT%H:%M:%S"

  def login(account, passw)

    @account  = account
    @passw    = passw

    self

  end # login

  def api
    @api ||= ::Cdek::Base.new(@account, @passw)
  end # api

  def calculate(params)
    calc.calculate(params)
  end # calculate

  def best_tariff(city_id)
    calc.best_tariff(city_id)
  end # best_tariff

  def generate_secure(date, pass)
    ::Digest::MD5.hexdigest("#{date}&#{pass}")
  end # generate_secure

  def debug_on

    @debug = true
    puts "[CdekApi] Отладочный режим ВКЛЮЧЕН"
    self

  end # debug_on

  def debug_off

    @debug = false
    puts "[CdekApi] Отладочный режим ОТКЛЮЧЕН"
    self

  end # debug_off

  def debug?
    @debug === true
  end # debug?

  def log(msg)

    puts(msg) if ::Cdek.debug?
    self

  end # log

  private

  def calc
    @calc ||= ::Cdek::Calculator.new(@account, @passw)
  end # calc

end # CdekApi

require 'documents/cdek_acceptance_report_document'

require "cdek_api/import"
require "cdek_api/railtie"    if defined?(::Rails)
