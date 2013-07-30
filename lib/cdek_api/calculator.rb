# encoding: utf-8
require 'json'

module Cdek

  class Calculator

    HOST      = 'api.edostavka.ru'
    PORT      = 80
    USE_SSL   = false
    VERSION   = 1.0
    URI       = '/calculator/calculate_price_by_json.php'

    TARIFFS   = {

      5   => {
        name:     "Экономичный экспресс склад-склад",
        courier:  false
      },

      10  => {
        name:     "Экспресс лайт склад-склад",
        courier:  false
      },

      11  => {
        name:     "Экспресс лайт склад-дверь",
        courier:  true
      },

      15  => {
        name:     "Экспресс тяжеловесы склад-склад",
        courier:  false
      },

      16  => {
        name:     "Экспресс тяжеловесы склад-дверь",
        courier:  true
      },

      62  => {
        name:     "Магистральный экспресс склад-склад",
        courier:  false
      },

      63  => {
        name:     "Магистральный супер-экспресс склад-склад",
        courier:  false
      },

      136 => {
        name:     "Посылка склад-склад",
        courier:  false
      },

      137 => {
        name:     "Посылка склад-дверь",
        courier:  true
      }

    }.freeze



    def initialize(account, pass)

      @account  = account
      @pass     = pass

    end # initialize

    def calculate(datas = {})

      opts = {

        version:        ::Cdek::Calculator::VERSION,
        dateExecute:    datas[:date_execute] || datas["date_execute"],
        senderCityId:   datas[:sender_city_id] || datas["sender_city_id"] || 259, # Челябинск
        receiverCityId: datas[:receiver_city_id] || datas["receiver_city_id"],
        tariffId:       datas[:tariff_id] || datas["tariff_id"],
        tariffList:     datas[:tariff_list] || datas["tariff_list"],
        modeId:         datas[:mode_id] || datas["mode_id"],
        goods:          datas[:goods] || datas["goods"]

      }

      opts[:dateExecute] = (opts[:dateExecute].try(:to_time) || ::Time.now).strftime("%Y-%m-%d")

      opts[:authLogin]  = @account
      opts[:secure]     = ::Cdek::generate_secure(opts[:dateExecute], @pass)

      pr  = opts.to_json
      uri = ::Cdek::Calculator::URI

      headers = {
        'Content-Type' => 'application/json'
      }

      data = []

      block_run do |http|

        ::Cdek.log("[calculate] => #{uri}  #{pr}")

        res = request do
          http.post(uri, pr, headers)
        end

        ::Cdek.log("[calculate] <= #{res.body}")

        data = ::JSON.parse(res.body) rescue {}

      end # block_run

      if data.empty?
        return [ false, [ ::Cdek::Calculator::UnknownError.new("Пустой ответ с сервера") ] ]
      elsif data["error"].is_a?(Array)

        errors = []

        data["error"].each do |err|
          errors << ::Cdek::Calculator.get_error(err["code"], err["text"])
        end

        return [ false, errors ]

      elsif !data["result"].nil?
        return [ true, data["result"] ]
      else
        return [ false, [ ::Cdek::Calculator::UnknownError.new("Неверный ответ с сервера: #{data.inspect}") ] ]
      end

    end # calculate

    def best_tariff(city_id)

      trf = {}

      ::Cdek::Calculator::TARIFFS.each do |key, values|

        res, datas = self.calculate({

          :receiver_city_id => city_id,
          :tariff_id        => key,
          :goods => [{
            weight: 0.1,
            length: 1,
            width:  1,
            height: 1
          }]

        })

        if res

          trf[ datas["price"].to_i ] = {

            min:      datas["deliveryPeriodMin"].try(:to_i),
            max:      datas["deliveryPeriodMax"].try(:to_i),
            price:    datas["price"].try(:to_i),
            tariff:   datas["tariffId"].try(:to_i),
            courier:  values[:courier] == true

          }

        end # if

      end # each

      res = Hash[*Hash[trf.sort].first].values.first
      res.nil? ? false : res

    end # best_tariff

    private

    def block_run

      ::Net::HTTP.start(
        ::Cdek::Calculator::HOST,
        ::Cdek::Calculator::PORT,
        :use_ssl => ::Cdek::Calculator::USE_SSL
      ) do |http|

        begin
          yield(http)
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end

      end

    end # block_run

    def request

      try_count = ::Cdek::RETRY

      res = yield
      while(try_count > 0 && res.code.to_i >= 300)

        ::Cdek.log("[retry] #{try_count}. Wait #{::Cdek::WAIT_TIME} sec.")

        res = yield
        try_count -= 1
        sleep ::Cdek::WAIT_TIME

      end # while

      res

    end # request

  end # Calculator

end # Cdek
