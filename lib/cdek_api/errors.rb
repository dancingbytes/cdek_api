# encoding: utf-8
module Cdek

  class Error < ::StandardError; end

  class UnknownError < ::Cdek::Error; end

  class InvaldXMLError < ::Cdek::Error; end

  class AuthError < ::Cdek::Error; end

  class NeedAttributeError < ::Cdek::Error; end

  class SendCityCodeError < ::Cdek::Error; end

  class RecCityCodeError < ::Cdek::Error; end

  class SendCityPostcodeError < ::Cdek::Error; end

  class RecCityPostcodeError < ::Cdek::Error; end

  class SendCityPostcodeDublError < ::Cdek::Error; end

  class RecCityPostcodeDublError < ::Cdek::Error; end

  class NotFoundSendCityError < ::Cdek::Error; end

  class NotFoundRecCityError < ::Cdek::Error; end

  class InvalidTariffTypeCodeError < ::Cdek::Error; end

  class InvalidServiceCodeError < ::Cdek::Error; end

  class NotFoundTariffTypeCodeError < ::Cdek::Error; end

  class NotEqualOrderCountError < ::Cdek::Error; end

  class NotEqualCallCountError < ::Cdek::Error; end

  class OrderDublError < ::Cdek::Error; end

  class ScheduleDublError < ::Cdek::Error; end

  class CallDublError < ::Cdek::Error; end

  class OrderDublExistsError < ::Cdek::Error; end

  class FirstDublExistsError < ::Cdek::Error; end

  class CashLimitError < ::Cdek::Error; end

  class CashNoError < ::Cdek::Error; end

  class InvalidWeightError < ::Cdek::Error; end

  class InvalidPaymentError < ::Cdek::Error; end

  class InvalidCostError < ::Cdek::Error; end

  class InvalidAmountError < ::Cdek::Error; end

  class InvalidDeliveryRecipientCostError < ::Cdek::Error; end

  class InvalidSizeError < ::Cdek::Error; end

  class DatabaseError < ::Cdek::Error; end

  class ScheduleChangeError < ::Cdek::Error; end

  class PackageNotFindError < ::Cdek::Error; end

  class ItemNotFindError < ::Cdek::Error; end

  class OrderDeleteError < ::Cdek::Error; end

  class InvalidNumberError < ::Cdek::Error; end

  class InfoRequestError < ::Cdek::Error; end

  class OrderCountError < ::Cdek::Error; end

  class FileNotExistsError < ::Cdek::Error; end

  class InvalidDispachNumberError < ::Cdek::Error; end

  class CallCourierTimeError < ::Cdek::Error; end

  class CallCourierTimeLunchError < ::Cdek::Error; end

  class CallCourierDatetimeError < ::Cdek::Error; end

  class CallCourierDateExistsError < ::Cdek::Error; end

  class CallCourierDateDublError < ::Cdek::Error; end

  class DeleteRequestOrderError < ::Cdek::Error; end

  class DeleteRequestOrderDeletedError < ::Cdek::Error; end

  class CallCourierTimeIntervalError < ::Cdek::Error; end

  class CallCourierCountError < ::Cdek::Error; end

  class CallCourierCityError < ::Cdek::Error; end

  class InfoRequestDateBegError < ::Cdek::Error; end

  class PVZNotFoundError < ::Cdek::Error; end

  class PVZCodeError < ::Cdek::Error; end

  class AttributeEmptyError < ::Cdek::Error; end

  def get_error(type, msg)

    case type

      when "ERR_INVALID_XML"            then ::Cdek::InvaldXMLError.new(msg)
      when "ERR_AUTH"                   then ::Cdek::AuthError.new(msg)
      when "ERR_NEED_ATTRIBUTE"         then ::Cdek::NeedAttributeError.new(msg)
      when "ERR_SENDCITYCODE"           then ::Cdek::SendCityCodeError.new(msg)
      when "ERR_RECCITYCODE"            then ::Cdek::RecCityCodeError.new(msg)
      when "ERR_SENDCITYPOSTCODE"       then ::Cdek::SendCityPostcodeError.new(msg)
      when "ERR_RECCITYPOSTCODE"        then ::Cdek::RecCityPostcodeError.new(msg)
      when "ERR_SENDCITYPOSTCODE_DUBL"  then ::Cdek::SendCityPostcodeDublError.new(msg)
      when "ERR_RECCITYPOSTCODE_DUBL"   then ::Cdek::RecCityPostcodeDublError.new(msg)
      when "ERR_NOT_FOUND_SENDCITY"     then ::Cdek::NotFoundSendCityError.new(msg)
      when "ERR_NOT_FOUND_RECCITY"      then ::Cdek::NotFoundRecCityError.new(msg)
      when "ERR_INVALID_TARIFFTYPECODE"   then ::Cdek::InvalidTariffTypeCodeError.new(msg)
      when "ERR_INVALID_SERVICECODE"      then ::Cdek::InvalidServiceCodeError.new(msg)
      when "ERR_NOT_FOUND_TARIFFTYPECODE" then ::Cdek::NotFoundTariffTypeCodeError.new(msg)
      when "ERR_NOT_EQUAL_ORDERCOUNT"   then ::Cdek::NotEqualOrderCountError.new(msg)
      when "ERR_NOT_EQUAL_CALLCOUNT"    then ::Cdek::NotEqualCallCountError.new(msg)
      when "ERR_ORDER_DUBL"             then ::Cdek::OrderDublError.new(msg)
      when "ERR_SCHEDULE_DUBL"          then ::Cdek::ScheduleDublError.new(msg)
      when "ERR_CALL_DUBL"              then ::Cdek::CallDublError.new(msg)
      when "ERR_ORDER_DUBL_EXISTS"      then ::Cdek::OrderDublExistsError.new(msg)
      when "ERR_FIRST_DUBL_EXISTS"      then ::Cdek::FirstDublExistsError.new(msg)
      when "ERR_CASH_LIMIT"             then ::Cdek::CashLimitError.new(msg)
      when "ERR_CASH_NO"                then ::Cdek::CashNoError.new(msg)

      when "ERR_INVALID_WEIGHT"         then ::Cdek::InvalidWeightError.new(msg)
      when "ERR_INVALID_PAYMENT"        then ::Cdek::InvalidPaymentError.new(msg)
      when "ERR_INVALID_COST"           then ::Cdek::InvalidCostError.new(msg)
      when "ERR_INVALID_AMOUNT"         then ::Cdek::InvalidAmountError.new(msg)
      when "ERR_INVALID_DELIVERYRECIPIENTCOST"  then ::Cdek::InvalidDeliveryRecipientCostError.new(msg)
      when "ERR_INVALID_SIZE"           then ::Cdek::InvalidSizeError.new(msg)
      when "ERR_DATABASE"               then ::Cdek::DatabaseError.new(msg)
      when "ERR_SCHEDULE_CHANGE"        then ::Cdek::ScheduleChangeError.new(msg)
      when "ERR_PACKAGE_NOTFIND"        then ::Cdek::PackageNotFindError.new(msg)
      when "ERR_ITEM_NOTFIND"           then ::Cdek::ItemNotFindError.new(msg)
      when "ERR_ORDER_DELETE"           then ::Cdek::OrderDeleteError.new(msg)
      when "ERR_INVALID_NUMBER"         then ::Cdek::InvalidNumberError.new(msg)
      when "ERR_INFOREQUEST"            then ::Cdek::InfoRequestError.new(msg)
      when "ERR_ORDER_COUNT"            then ::Cdek::OrderCountError.new(msg)
      when "ERR_FILE_NOTEXISTS"         then ::Cdek::FileNotExistsError.new(msg)

      when "ERR_INVALID_DISPACHNUMBER"  then ::Cdek::InvalidDispachNumberError.new(msg)
      when "ERR_CALLCOURIER_TIME"       then ::Cdek::CallCourierTimeError.new(msg)
      when "ERR_CALLCOURIER_TIMELUNCH"  then ::Cdek::CallCourierTimeLunchError.new(msg)
      when "ERR_CALLCOURIER_DATETIME"   then ::Cdek::CallCourierDatetimeError.new(msg)
      when "ERR_CALLCOURIER_DATE_EXISTS"  then ::Cdek::CallCourierDateExistsError.new(msg)
      when "ERR_CALLCOURIER_DATE_DUBL"    then ::Cdek::CallCourierDateDublError.new(msg)
      when "ERR_DELETEREQUEST_ORDER"      then ::Cdek::DeleteRequestOrderError.new(msg)
      when "ERR_DELETEREQUEST_ORDER_DELETED"  then ::Cdek::DeleteRequestOrderDeletedError.new(msg)
      when "ERR_CALLCOURIER_TIME_INTERVAL"    then ::Cdek::CallCourierTimeIntervalError.new(msg)
      when "ERR_CALLCOURIER_COUNT"      then ::Cdek::CallCourierCountError.new(msg)
      when "ERR_CALLCOURIER_CITY"       then ::Cdek::CallCourierCityError.new(msg)
      when "ERR_INFOREQUEST_DATEBEG"    then ::Cdek::InfoRequestDateBegError.new(msg)
      when "ERR_PVZ_NOTFOUND"           then ::Cdek::PVZNotFoundError.new(msg)
      when "ERR_PVZCODE"                then ::Cdek::PVZCodeError.new(msg)
      when "ERR_ATTRIBUTE_EMPTY"        then ::Cdek::AttributeEmptyError.new(msg)

    else
      ::Cdek::UnknownError.new(msg)

    end # case

  end # get_error

end # Cdek
