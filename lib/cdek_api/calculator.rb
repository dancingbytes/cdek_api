# encoding: utf-8
require 'json'

module CdekApi

  class Calculator

    def initialize(account, pass)

      @account  = account
      @pass     = pass

    end # initialize

    def calculate(datas = {})

      opts = {

        version:        "1.0",
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
      opts[:secure]     = ::CdekApi::generate_secure(opts[:dateExecute], @pass)

      pr  = opts.to_json
      uri = '/calculator/calculate_price_by_json.php'

      headers = {
        'Content-Type' => 'application/json'
      }

      data = []

      block_run do |http|

        ::CdekApi.log("[calculate] => #{uri}  #{pr}")

        res  = http.post(uri, pr, headers)
        data = ::JSON.parse(res.body) rescue {}

        ::CdekApi.log("[calculate] <= #{res.body}")

      end # block_run

      if data.empty?
        return [ false, ::CdekApi::Calculator::UnknownError.new("Пустой ответ с сервера") ]
      elsif data["error"].is_a?(Array)

        errors = []

        data["error"].each do |err|
          errors << ::CdekApi::Calculator.get_error(err["code"], err["text"])
        end

        return [ false, errors ]

      elsif !data["result"].nil?
        return [ true, data["result"] ]
      else
        return [ false, ::CdekApi::Calculator::UnknownError.new("Неверный ответ с сервера: #{data.inspect}") ]
      end

    end # calculate

    private

    def block_run

      ::Net::HTTP.start(
        ::CdekApi::CALC_HOST,
        ::CdekApi::CALC_PORT,
        :use_ssl => ::CdekApi::CALC_USE_SSL
      ) do |http|

        begin
          yield(http)
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end

      end

    end # block_run

  end # Calculator

end # CdekApi
