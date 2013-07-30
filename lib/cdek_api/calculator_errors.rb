# encoding: utf-8
module Cdek

  class Calculator

    class Error < ::StandardError; end

    class UnknownError < ::Cdek::Calculator::Error; end

    class ServerError < ::Cdek::Calculator::Error; end

    class ApiVersionError < ::Cdek::Calculator::Error; end

    class AuthError < ::Cdek::Calculator::Error; end

    class DeliveryError < ::Cdek::Calculator::Error; end

    class PlaceError < ::Cdek::Calculator::Error; end

    class PlaceDeliveryError < ::Cdek::Calculator::Error; end

    class TariffError < ::Cdek::Calculator::Error; end

    class SenderCityError < ::Cdek::Calculator::Error; end

    class ReceiverCityError < ::Cdek::Calculator::Error; end

    class DateError < ::Cdek::Calculator::Error; end

    class DeliveryTypeError < ::Cdek::Calculator::Error; end

    class FormatError < ::Cdek::Calculator::Error; end

    class DecodeError < ::Cdek::Calculator::Error; end

    class SenderPostcodeNotFoundError < ::Cdek::Calculator::Error; end

    class SenderPostcodeError < ::Cdek::Calculator::Error; end

    class ReceiverPostcodeNotFoundError < ::Cdek::Calculator::Error; end

    class ReceiverPostcodeError < ::Cdek::Calculator::Error; end


    def self.get_error(type, msg)

      case type

        when 0  then ::Cdek::Calculator::ServerError.new(msg)
        when 1  then ::Cdek::Calculator::ApiVersionError.new(msg)
        when 2  then ::Cdek::Calculator::AuthError.new(msg)
        when 3  then ::Cdek::Calculator::DeliveryError.new(msg)
        when 4  then ::Cdek::Calculator::PlaceError.new(msg)
        when 5  then ::Cdek::Calculator::PlaceDeliveryError.new(msg)
        when 6  then ::Cdek::Calculator::TariffError.new(msg)
        when 7  then ::Cdek::Calculator::SenderCityError.new(msg)
        when 8  then ::Cdek::Calculator::ReceiverCityError.new(msg)
        when 9  then ::Cdek::Calculator::DateError.new(msg)
        when 10 then ::Cdek::Calculator::DeliveryTypeError.new(msg)
        when 11 then ::Cdek::Calculator::FormatError.new(msg)
        when 12 then ::Cdek::Calculator::DecodeError.new(msg)
        when 13 then ::Cdek::Calculator::SenderPostcodeNotFoundError.new(msg)
        when 14 then ::Cdek::Calculator::SenderPostcodeError.new(msg)
        when 15 then ::Cdek::Calculator::ReceiverPostcodeNotFoundError.new(msg)
        when 16 then ::Cdek::Calculator::ReceiverPostcodeError.new(msg)

      else
        ::Cdek::Calculator::UnknownError.new(msg)

      end # case

    end # get_error

  end # Calculator

end # Cdek
