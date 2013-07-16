# encoding: utf-8
module CdekApi

  class Error < ::StandardError; end

  class UnknownError < ::CdekApi::Error; end

  class InvaldXMLError < ::CdekApi::Error; end

  class AuthError < ::CdekApi::Error; end

  class NeedAttributeError < ::CdekApi::Error; end

  class SendCityCodeError < ::CdekApi::Error; end

  class RecCityCodeError < ::CdekApi::Error; end

  class SendCityPostcodeError < ::CdekApi::Error; end

  class RecCityPostcodeError < ::CdekApi::Error; end

  class SendCityPostcodeDublError < ::CdekApi::Error; end

  class RecCityPostcodeDublError < ::CdekApi::Error; end

  class NotFoundSendCityError < ::CdekApi::Error; end

  class NotFoundRecCityError < ::CdekApi::Error; end

  class InvalidTariffTypeCodeError < ::CdekApi::Error; end

  class InvalidServiceCodeError < ::CdekApi::Error; end

  class NotFoundTariffTypeCodeError < ::CdekApi::Error; end

  class NotEqualOrderCountError < ::CdekApi::Error; end

  class NotEqualCallCountError < ::CdekApi::Error; end

  class OrderDublError < ::CdekApi::Error; end

  class ScheduleDublError < ::CdekApi::Error; end

  class CallDublError < ::CdekApi::Error; end

  class OrderDublExistsError < ::CdekApi::Error; end

  class FirstDublExistsError < ::CdekApi::Error; end

  class CashLimitError < ::CdekApi::Error; end

  class CashNoError < ::CdekApi::Error; end

  class InvalidWeightError < ::CdekApi::Error; end

  class InvalidPaymentError < ::CdekApi::Error; end

  class InvalidCostError < ::CdekApi::Error; end

  class InvalidAmountError < ::CdekApi::Error; end

  class InvalidDeliveryRecipientCostError < ::CdekApi::Error; end

  class InvalidSizeError < ::CdekApi::Error; end

  class DatabaseError < ::CdekApi::Error; end

  class ScheduleChangeError < ::CdekApi::Error; end

  class PackageNotFindError < ::CdekApi::Error; end

  class ItemNotFindError < ::CdekApi::Error; end

  class OrderDeleteError < ::CdekApi::Error; end

  class InvalidNumberError < ::CdekApi::Error; end

  class InfoRequestError < ::CdekApi::Error; end

  class OrderCountError < ::CdekApi::Error; end

  class FileNotExistsError < ::CdekApi::Error; end

  class InvalidDispachNumberError < ::CdekApi::Error; end

  class CallCourierTimeError < ::CdekApi::Error; end

  class CallCourierTimeLunchError < ::CdekApi::Error; end

  class CallCourierDatetimeError < ::CdekApi::Error; end

  class CallCourierDateExistsError < ::CdekApi::Error; end

  class CallCourierDateDublError < ::CdekApi::Error; end

  class DeleteRequestOrderError < ::CdekApi::Error; end

  class DeleteRequestOrderDeletedError < ::CdekApi::Error; end

  class CallCourierTimeIntervalError < ::CdekApi::Error; end

  class CallCourierCountError < ::CdekApi::Error; end

  class CallCourierCityError < ::CdekApi::Error; end

  class InfoRequestDateBegError < ::CdekApi::Error; end

  class PVZNotFoundError < ::CdekApi::Error; end

  class PVZCodeError < ::CdekApi::Error; end

  class AttributeEmptyError < ::CdekApi::Error; end

  def get_error(type, msg)

    case type

      when "ERR_INVALID_XML"            then ::CdekApi::InvaldXMLError.new(msg)
      when "ERR_AUTH"                   then ::CdekApi::AuthError.new(msg)
      when "ERR_NEED_ATTRIBUTE"         then ::CdekApi::NeedAttributeError.new(msg)
      when "ERR_SENDCITYCODE"           then ::CdekApi::SendCityCodeError.new(msg)
      when "ERR_RECCITYCODE"            then ::CdekApi::RecCityCodeError.new(msg)
      when "ERR_SENDCITYPOSTCODE"       then ::CdekApi::SendCityPostcodeError.new(msg)
      when "ERR_RECCITYPOSTCODE"        then ::CdekApi::RecCityPostcodeError.new(msg)
      when "ERR_SENDCITYPOSTCODE_DUBL"  then ::CdekApi::SendCityPostcodeDublError.new(msg)
      when "ERR_RECCITYPOSTCODE_DUBL"   then ::CdekApi::RecCityPostcodeDublError.new(msg)
      when "ERR_NOT_FOUND_SENDCITY"     then ::CdekApi::NotFoundSendCityError.new(msg)
      when "ERR_NOT_FOUND_RECCITY"      then ::CdekApi::NotFoundRecCityError.new(msg)
      when "ERR_INVALID_TARIFFTYPECODE"   then ::CdekApi::InvalidTariffTypeCodeError.new(msg)
      when "ERR_INVALID_SERVICECODE"      then ::CdekApi::InvalidServiceCodeError.new(msg)
      when "ERR_NOT_FOUND_TARIFFTYPECODE" then ::CdekApi::NotFoundTariffTypeCodeError.new(msg)
      when "ERR_NOT_EQUAL_ORDERCOUNT"   then ::CdekApi::NotEqualOrderCountError.new(msg)
      when "ERR_NOT_EQUAL_CALLCOUNT"    then ::CdekApi::NotEqualCallCountError.new(msg)
      when "ERR_ORDER_DUBL"             then ::CdekApi::OrderDublError.new(msg)
      when "ERR_SCHEDULE_DUBL"          then ::CdekApi::ScheduleDublError.new(msg)
      when "ERR_CALL_DUBL"              then ::CdekApi::CallDublError.new(msg)
      when "ERR_ORDER_DUBL_EXISTS"      then ::CdekApi::OrderDublExistsError.new(msg)
      when "ERR_FIRST_DUBL_EXISTS"      then ::CdekApi::FirstDublExistsError.new(msg)
      when "ERR_CASH_LIMIT"             then ::CdekApi::CashLimitError.new(msg)
      when "ERR_CASH_NO"                then ::CdekApi::CashNoError.new(msg)

      when "ERR_INVALID_WEIGHT"         then ::CdekApi::InvalidWeightError.new(msg)
      when "ERR_INVALID_PAYMENT"        then ::CdekApi::InvalidPaymentError.new(msg)
      when "ERR_INVALID_COST"           then ::CdekApi::InvalidCostError.new(msg)
      when "ERR_INVALID_AMOUNT"         then ::CdekApi::InvalidAmountError.new(msg)
      when "ERR_INVALID_DELIVERYRECIPIENTCOST"  then ::CdekApi::InvalidDeliveryRecipientCostError.new(msg)
      when "ERR_INVALID_SIZE"           then ::CdekApi::InvalidSizeError.new(msg)
      when "ERR_DATABASE"               then ::CdekApi::DatabaseError.new(msg)
      when "ERR_SCHEDULE_CHANGE"        then ::CdekApi::ScheduleChangeError.new(msg)
      when "ERR_PACKAGE_NOTFIND"        then ::CdekApi::PackageNotFindError.new(msg)
      when "ERR_ITEM_NOTFIND"           then ::CdekApi::ItemNotFindError.new(msg)
      when "ERR_ORDER_DELETE"           then ::CdekApi::OrderDeleteError.new(msg)
      when "ERR_INVALID_NUMBER"         then ::CdekApi::InvalidNumberError.new(msg)
      when "ERR_INFOREQUEST"            then ::CdekApi::InfoRequestError.new(msg)
      when "ERR_ORDER_COUNT"            then ::CdekApi::OrderCountError.new(msg)
      when "ERR_FILE_NOTEXISTS"         then ::CdekApi::FileNotExistsError.new(msg)

      when "ERR_INVALID_DISPACHNUMBER"  then ::CdekApi::InvalidDispachNumberError.new(msg)
      when "ERR_CALLCOURIER_TIME"       then ::CdekApi::CallCourierTimeError.new(msg)
      when "ERR_CALLCOURIER_TIMELUNCH"  then ::CdekApi::CallCourierTimeLunchError.new(msg)
      when "ERR_CALLCOURIER_DATETIME"   then ::CdekApi::CallCourierDatetimeError.new(msg)
      when "ERR_CALLCOURIER_DATE_EXISTS"  then ::CdekApi::CallCourierDateExistsError.new(msg)
      when "ERR_CALLCOURIER_DATE_DUBL"    then ::CdekApi::CallCourierDateDublError.new(msg)
      when "ERR_DELETEREQUEST_ORDER"      then ::CdekApi::DeleteRequestOrderError.new(msg)
      when "ERR_DELETEREQUEST_ORDER_DELETED"  then ::CdekApi::DeleteRequestOrderDeletedError.new(msg)
      when "ERR_CALLCOURIER_TIME_INTERVAL"    then ::CdekApi::CallCourierTimeIntervalError.new(msg)
      when "ERR_CALLCOURIER_COUNT"      then ::CdekApi::CallCourierCountError.new(msg)
      when "ERR_CALLCOURIER_CITY"       then ::CdekApi::CallCourierCityError.new(msg)
      when "ERR_INFOREQUEST_DATEBEG"    then ::CdekApi::InfoRequestDateBegError.new(msg)
      when "ERR_PVZ_NOTFOUND"           then ::CdekApi::PVZNotFoundError.new(msg)
      when "ERR_PVZCODE"                then ::CdekApi::PVZCodeError.new(msg)
      when "ERR_ATTRIBUTE_EMPTY"        then ::CdekApi::AttributeEmptyError.new(msg)

    else
      ::CdekApi::UnknownError.new(msg)

    end # case

  end # get_error

end # CdekApi
