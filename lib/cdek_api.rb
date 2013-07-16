# encoding: utf-8
require 'net/http'
require 'digest/md5'

require "cdek_api/version"
require "cdek_api/ext"
require "cdek_api/cities"
require "cdek_api/delivery"

require "cdek_api/errors"
require "cdek_api/calculator_errors"

require "cdek_api/base"
require "cdek_api/calculator"

require "cdek_api/import"

require "cdek_api/railtie"    if defined?(::Rails)

module CdekApi

  extend self

  CALC_HOST     = 'api.edostavka.ru'
  CALC_PORT     = 80
  CALC_USE_SSL  = false

  HOST          = 'gw.edostavka.ru'
  PORT          = 11443
  USE_SSL       = false

  DATE_FORMAT   = "%Y-%m-%dT%H:%M:%S"

  def login(account, passw)

    @account  = account
    @passw    = passw

    self

  end # login

  def api
    @api ||= ::CdekApi::Base.new(@account, @passw)
  end # api

  def calculate(params)

    @calc ||= ::CdekApi::Calculator.new(@account, @passw)
    @calc.calculate(params)

  end # calculate

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

    puts(msg) if ::CdekApi.debug?
    self

  end # log

end # CdekApi
