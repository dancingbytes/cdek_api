# encoding: utf-8
module Cdek

  module Respond

    extend self

    def pvz_list(body, xpath, err_xpath)

      doc = ::Nokogiri::XML::Document.parse(body)
      result = doc.search(xpath)

      if result.size > 0

        result.each do |node|
          yield(node)
        end # search

        return true

      else

        if (result = doc.search(err_xpath).first)
          return ::Cdek.get_error(result["ErrorCode"], result["Msg"])
        else
          return ::Cdek::UnknownError.new("Неизветсная ошибка")
        end

      end # if

    end # pvz_list

  end # Respond

end # Cdek
