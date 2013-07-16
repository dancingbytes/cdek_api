# encoding: utf-8
module CdekApi

  class Calculator

    class Error < ::StandardError; end

    class UnknownError < ::CdekApi::Calculator::Error; end

    class ServerError < ::CdekApi::Calculator::Error; end

    class ApiVersionError < ::CdekApi::Calculator::Error; end

    class AuthError < ::CdekApi::Calculator::Error; end

    class DeliveryError < ::CdekApi::Calculator::Error; end

    class PlaceError < ::CdekApi::Calculator::Error; end

    class PlaceDeliveryError < ::CdekApi::Calculator::Error; end

    class TariffError < ::CdekApi::Calculator::Error; end

    class SenderCityError < ::CdekApi::Calculator::Error; end

    class ReceiverCityError < ::CdekApi::Calculator::Error; end

    class DateError < ::CdekApi::Calculator::Error; end

    class DeliveryTypeError < ::CdekApi::Calculator::Error; end

    class FormatError < ::CdekApi::Calculator::Error; end

    class DecodeError < ::CdekApi::Calculator::Error; end

    class SenderPostcodeNotFoundError < ::CdekApi::Calculator::Error; end

    class SenderPostcodeError < ::CdekApi::Calculator::Error; end

    class ReceiverPostcodeNotFoundError < ::CdekApi::Calculator::Error; end

    class ReceiverPostcodeError < ::CdekApi::Calculator::Error; end


    def self.get_error(type, msg)

      case type

        when 0  then ::CdekApi::Calculator::ServerError.new(msg)
        when 1  then ::CdekApi::Calculator::ApiVersionError.new(msg)
        when 2  then ::CdekApi::Calculator::AuthError.new(msg)
        when 3  then ::CdekApi::Calculator::DeliveryError.new(msg)
        when 4  then ::CdekApi::Calculator::PlaceError.new(msg)
        when 5  then ::CdekApi::Calculator::PlaceDeliveryError.new(msg)
        when 6  then ::CdekApi::Calculator::TariffError.new(msg)
        when 7  then ::CdekApi::Calculator::SenderCityError.new(msg)
        when 8  then ::CdekApi::Calculator::ReceiverCityError.new(msg)
        when 9  then ::CdekApi::Calculator::DateError.new(msg)
        when 10 then ::CdekApi::Calculator::DeliveryTypeError.new(msg)
        when 11 then ::CdekApi::Calculator::FormatError.new(msg)
        when 12 then ::CdekApi::Calculator::DecodeError.new(msg)
        when 13 then ::CdekApi::Calculator::SenderPostcodeNotFoundError.new(msg)
        when 14 then ::CdekApi::Calculator::SenderPostcodeError.new(msg)
        when 15 then ::CdekApi::Calculator::ReceiverPostcodeNotFoundError.new(msg)
        when 16 then ::CdekApi::Calculator::ReceiverPostcodeError.new(msg)

      else
        ::CdekApi::Calculator::UnknownError.new(msg)

      end # case

    end # get_error

  end # Calculator

end # CdekApi
