# encoding: utf-8
class CdekApiMailer < ::ActionMailer::Base

  default from: "Anlas.ru <info@anlas.ru>",
          to:   "Ivan <ivan@anlas.ru>"

  def errors(file)

    attachments['errors.xml'] = file

    mail(:subject => 'Anlas [Cdek]: ошибки обработки заказов') do |format|

      format.html {

        render :text => <<-"expression"
          <!DOCTYPE html>
          <html>
            <head>
              <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
            </head>
            <body>Ошибки обработки заказов в приложении к письму.</body>
          </html>
        expression

      }

    end # do

  end # errors

end # CdekApiMailer
