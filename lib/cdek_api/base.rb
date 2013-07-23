# encoding: utf-8
require 'nokogiri'

module CdekApi

  class Base

    def initialize(account, pass)

      @account  = account
      @date     = ::Time.now.utc.strftime(::CdekApi::DATE_FORMAT)
      @secure   = ::CdekApi::generate_secure(@date, pass)

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

        ::CdekApi.log("[pvz_list] => #{uri}")

        res = request do
          http.get(uri)
        end

        ::CdekApi.log("[pvz_list] <= #{res.body}")

        result = answer(res.body, ".//PvzList/Pvz", ".//PvzList") do |node|

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

    # Список заказов на доставку
    def list_of_orders_for_delivery

    end # list_of_orders_for_delivery

    def list_of_orders_for_removal

    end # list_of_orders_for_removal

    private

    def answer(body, xpath, err_xpath = ".//PvzList")

      doc = ::Nokogiri::XML::Document.parse(body)
      result = doc.search(xpath)

      if result.size > 0

        result.each do |node|
          yield(node)
        end # search

        return true

      else

        if (result = doc.search(err_xpath).first)
          return ::CdekApi.get_error(result["ErrorCode"], result["Msg"])
        else
          return ::CdekApi::UnknownError.new("Неизветсная ошибка")
        end

      end # if

    end # answer

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
        ::CdekApi::HOST,
        ::CdekApi::PORT,
        :use_ssl => ::CdekApi::USE_SSL
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

  end # Base

end # CdekApi
