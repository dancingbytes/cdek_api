# encoding: utf-8
module Cdek

  class Base

    def initialize(account, pass)

      @account  = account
      @date     = ::Time.now.utc.strftime(::Cdek::DATE_FORMAT)
      @secure   = ::Cdek::generate_secure(@date, pass)

    end # initialize

    def date
      @date
    end # date

    # Список пунктов выдачи заказов
    def pvz_list(city_id = nil)

      data    = []
      result  = false

      block_run do |http|

        uri = url_for("pvzlist", {
          cityid: city_id
        })

        ::Cdek.log("[pvz_list] => #{uri}")

        res = request do
          http.get(uri)
        end

        ::Cdek.log("[pvz_list] <= #{res.body}")

        result = ::Cdek::Respond.pvz_list(res.body, ".//PvzList/Pvz", ".//PvzList") do |node|

          data << {
            city_code: node["CityCode"],
            work_time: node["WorkTime"],
            address:   node["Address"].first_capitalize,
            phone:     node["Phone"]
          }

        end

      end # block_run

      result == true ? [ true, data ] : [ false, result ]

    end # pvz_list

    # Статусы заказов
    def states_orders
    end # states_orders

    # Информация по заказам
    def info_orders
    end # info_orders

    # Список заказов на доставку
    def list_orders_for_delivery

    end # list_of_orders_for_delivery

    def list_orders_for_removal

    end # list_of_orders_for_removal

    private

    def url_for(func = nil, datas = {})

      datas.delete_if { |k, v| v.nil? || v == '' }

      datas[:account] = @account
      datas[:secure]  = @secure

      uri = "/"
      uri << "#{func}.php" unless func.nil?
      uri << "?"
      uri << ::URI.encode_www_form(datas)

      uri

    end # url_for

    def block_run

      ::Net::HTTP.start(
        ::Cdek::HOST,
        ::Cdek::PORT,
        :use_ssl => ::Cdek::USE_SSL
      ) do |http|

        begin
          yield(http)
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
        end

      end # start

      self

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

  end # Base

end # Cdek
