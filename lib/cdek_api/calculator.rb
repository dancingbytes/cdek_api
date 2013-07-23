# encoding: utf-8
require 'json'

module CdekApi

  class Calculator

    HOST      = 'api.edostavka.ru'
    PORT      = 80
    USE_SSL   = false
    VERSION   = 1.0
    URI       = '/calculator/calculate_price_by_json.php'

    TARIFFS   = {

#      1   => "Экспресс лайт дверь-дверь",
#      3   => "Супер-экспресс до 18",
#      4   => "Рассылка",
      5   => "Экономичный экспресс склад-склад",
#      7   => "Международный экспресс документы",
#      8   => "Международный экспресс грузы",
      10  => "Экспресс лайт склад-склад",
      11  => "Экспресс лайт склад-дверь",
#      12  => "Экспресс лайт дверь-склад",
      15  => "Экспресс тяжеловесы склад-склад",
      16  => "Экспресс тяжеловесы склад-дверь",
#      17  => "Экспресс тяжеловесы дверь-склад",
#      18  => "Экспресс тяжеловесы дверь-дверь",
#      57  => "Супер-экспресс до 9",
#      58  => "Супер-экспресс до 10",
#      59  => "Супер-экспресс до 12",
#      60  => "Супер-экспресс до 14",
#      61  => "Супер-экспресс до 16",
      62  => "Магистральный экспресс склад-склад",
      63  => "Магистральный супер-экспресс склад-склад",
#      66  => "Блиц-экспресс 01",
#      67  => "Блиц-экспресс 02",
#      68  => "Блиц-экспресс 03",
#      69  => "Блиц-экспресс 04",
#      70  => "Блиц-экспресс 05",
#      71  => "Блиц-экспресс 06",
#      72  => "Блиц-экспресс 07",
#      73  => "Блиц-экспресс 08",
#      74  => "Блиц-экспресс 09",
#      75  => "Блиц-экспресс 10",
#      76  => "Блиц-экспресс 11",
#      77  => "Блиц-экспресс 12",
#      78  => "Блиц-экспресс 13",
#      79  => "Блиц-экспресс 14",
#      80  => "Блиц-экспресс 15",
#      81  => "Блиц-экспресс 16",
#      82  => "Блиц-экспресс 17",
#      83  => "Блиц-экспресс 18",
#      84  => "Блиц-экспресс 19",
#      85  => "Блиц-экспресс 20",
#      86  => "Блиц-экспресс 21",
#      87  => "Блиц-экспресс 22",
#      88  => "Блиц-экспресс 23",
#      89  => "Блиц-экспресс 24",
      136 => "Посылка склад-склад",
      137 => "Посылка склад-дверь"
#      138 => "Посылка дверь-склад",
#      139 => "Посылка дверь-дверь"

    }.freeze

    def initialize(account, pass)

      @account  = account
      @pass     = pass

    end # initialize

    def calculate(datas = {})

      opts = {

        version:        ::CdekApi::Calculator::VERSION,
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
      uri = ::CdekApi::Calculator::URI

      headers = {
        'Content-Type' => 'application/json'
      }

      data = []

      block_run do |http|

        ::CdekApi.log("[calculate] => #{uri}  #{pr}")

        res = request do
          http.post(uri, pr, headers)
        end

        ::CdekApi.log("[calculate] <= #{res.body}")

        data = ::JSON.parse(res.body) rescue {}

      end # block_run

      if data.empty?
        return [ false, [ ::CdekApi::Calculator::UnknownError.new("Пустой ответ с сервера") ] ]
      elsif data["error"].is_a?(Array)

        errors = []

        data["error"].each do |err|
          errors << ::CdekApi::Calculator.get_error(err["code"], err["text"])
        end

        return [ false, errors ]

      elsif !data["result"].nil?
        return [ true, data["result"] ]
      else
        return [ false, [ ::CdekApi::Calculator::UnknownError.new("Неверный ответ с сервера: #{data.inspect}") ] ]
      end

    end # calculate

    def best_tariff(city_id)

      trf = {}

      ::CdekApi::Calculator::TARIFFS.each do |key, value|

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

            min:    datas["deliveryPeriodMin"].try(:to_i),
            max:    datas["deliveryPeriodMax"].try(:to_i),
            price:  datas["price"].try(:to_i),
            tariff: datas["tariffId"].try(:to_i)

          }

        end # if

      end # each

      res = Hash[*Hash[trf.sort].first].values.first
      res.nil? ? false : res

    end # best_tariff

    private

    def block_run

      ::Net::HTTP.start(
        ::CdekApi::Calculator::HOST,
        ::CdekApi::Calculator::PORT,
        :use_ssl => ::CdekApi::Calculator::USE_SSL
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

      try_count = ::CdekApi::RETRY

      res = yield
      while(try_count > 0 && res.code.to_i >= 300)

        ::CdekApi.log("[retry] #{try_count}. Wait #{::CdekApi::WAIT_TIME} sec.")

        res = yield
        try_count -= 1
        sleep ::CdekApi::WAIT_TIME

      end # while

      res

    end # request

  end # Calculator

end # CdekApi
