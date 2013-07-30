# encoding: utf-8
module Cdek

  module AcceptanceReport

    class Snippets

      extend ::ActionView::Helpers::NumberHelper

      def self.method_missing(name, *args, &block)
        "not found"
      end # method_missing

      def initialize(data)
        @data = data
      end # new

      def doc_num
        @data.doc_num
      end # doc_num

      def doc_day
        @data.doc_day
      end # doc_day

      def doc_month
        @data.doc_month
      end # doc_month

      def doc_year
        @data.doc_year
      end # doc_year

      def items_count
        @data.items.length
      end # items_count

      def items

        str = ""
        i   = 0

        @data.items.each do |item|

          i += 1

          str << "<tr>"
            str << "<td class=\"num\">#{i}</td>"
            str << "<td class=\"order\">#{item['order_num']}</td>"
            str << "<td class=\"weight\">#{item['weight']}</td>"
            str << "<td class=\"price\">#{item['delivery_price']}</td>"
            str << "<td class=\"total\">#{item['total_price']}</td>"
          str << "<tr>"

        end # each

        str

      end # items

      def declared_value

        coop = ( (@data.declared_value.to_f - @data.declared_value.to_i).round(2)*100 ).to_i
        coop = 0 if coop == 100

        str = @data.declared_value.to_count(["рубль", "рубля", "рублей", "ноль рублей"]) do |num, s|
          (num.to_human + " " + s).first_capitalize
        end

        str << coop.to_count(["копейка", "копейки", "копеек", " 00 копеек"]) do |num, s|
          " " + String(num).rjust(2, '00') + " " + s
        end

        "#{@data.declared_value.round(2)} руб. #{str}"

      end # declared_value

      def principal_name
        @data.principal_name
      end # principal_name

      def principal_based_on
        @data.principal_based_on
      end # principal_based_on

      def principal_on_face
        @data.principal_on_face
      end # principal_on_face

      def principal_position
        @data.principal_position
      end # principal_position

      def principal_fio
        @data.principal_fio
      end # principal_fio

      def agent_name
        @data.agent_name
      end # agent_name

      def agent_based_on
        @data.agent_based_on
      end # agent_based_on

      def agent_on_face
        @data.agent_on_face
      end # agent_on_face

      def agent_position
        @data.agent_position
      end # agent_position

      def agent_fio
        @data.agent_fio
      end # agent_fio

      def contract_num
        @data.contract_num
      end # contract_num

      def contract_day
        @data.contract_day
      end # contract_day

      def contract_month
        @data.contract_month
      end # contract_month

      def contract_year
        @data.contract_year
      end # contract_year

      private

      def method_missing(name, *args, &block)
        "not found"
      end # method_missing

    end # Snippets

    class Document

      def initialize(datas)

        # Переменные
        @snippets   = ::Cdek::AcceptanceReport::Snippets.new(datas)

        # Файловый менеджер
        @multimedia = ::Multimedia.new

      end # new

      # Реестр документов
      def save

        file = ::File.join(File.dirname(__FILE__), "templates", "cdek_acceptance_report_document.html")

        return false unless ::File.exists?(file)

        content = ::File.read(file)
        marks   = content.scan(/\{([[:alpha:]][A-Za-z0-9\_]+)\}/i) || []

        marks.flatten!
        marks.uniq!
        marks.compact!

        marks.each do |mark|

          content.gsub!(
            /{#{mark}}/,
            (@snippets.send(mark.to_sym) || "").to_s
          )

        end # each

        begin

          pdf = ::PDFKit.new(content)

          @multimedia.file_upload = pdf.to_file("/tmp/#{::Time.now.to_f}-#{rand}.pdf")
          @multimedia.save

        rescue => e

          ::Rails.logger.tagged("CdekAcceptanceReportDocument") {
            ::Rails.logger.error(e.message)
          }
          false

        end

      end # save

      def ext
        @multimedia.ext
      end # ext

      def url
        @multimedia.url
      end # url

      def size
        @multimedia.size
      end # size

    end # Document

    class Base

      DEFAULTS = {

        principal_name:     ->() { "ООО «Анлас»" },
        principal_on_face:  ->() { "Балакирева Дмитрия Алексеевича" },
        principal_based_on: ->() { "Устава" },

        agent_name:         ->() { "ООО \"УК СДЭК\"" },
        agent_on_face:      ->() { "Директора Гольдорта Л. Я." },
        agent_based_on:     ->() { "Устава" },

        doc_num:            ->() { self.get_number },
        doc_date:           ->() { ::Time.now },
        contract_num:       ->() { "ИМ4073" },
        contract_date:      ->() { ::Time.new(2013, 6, 19) }

      }.freeze

      include ::ActiveModel::Validations
      include ::ActiveModel::Conversion
      extend  ::ActiveModel::Naming

      attr_accessor :doc_num,
                    :doc_date,
                    :contract_num,
                    :contract_date,
                    :items,

                    :principal_name,
                    :principal_based_on,
                    :principal_on_face,
                    :principal_position,
                    :principal_fio,

                    :agent_name,
                    :agent_based_on,
                    :agent_on_face,
                    :agent_position,
                    :agent_fio

      validates_presence_of :contract_num,
                            :contract_date,

                            :principal_name,
                            :principal_based_on,
                            :principal_on_face,

                            :agent_name,
                            :agent_based_on,
                            :agent_on_face

      class << self

        def get_number

          counter = ::Mongoid.default_session['admin'].
            find(:name => "CdekARD_0").
            modify({ "$inc" => { count: 1 } }, { upsert: true, new: true })["count"]

          "#{counter.to_s}"

        end # get_number

      end # class << self

      def initialize(attributes = nil)

        (attributes || {}).each do |name, value|

          method = "#{name}=".to_sym
          send(method, prepare_val(value) ) if self.respond_to?(method)

        end # each

        set_defaults_if_empty

      end # new

      def persisted?; false; end

      def save

        return false unless self.valid?
        return false unless validate_items

        @doc = ::Cdek::AcceptanceReport::Document.new(self)
        @doc.save

      end # save

      def ext
        @doc ? @doc.ext : nil
      end # ext

      def url
        @doc ? @doc.url : nil
      end # url

      def size
        @doc ? @doc.size : nil
      end # size

      def doc_date
        @doc_date.to_time rescue ::Time.now
      end # doc_date

      def doc_day
        doc_date.day
      end # doc_day

      def doc_month
        ::I18n.t('date.month_names')[doc_date.mon]
      end # doc_month

      def doc_year
        doc_date.year
      end # doc_year

      def contract_date
        @contract_date.to_time rescue ::Time.now
      end # contract_date

      def contract_day
        contract_date.day
      end # contract_day

      def contract_month
        ::I18n.t('date.month_names')[contract_date.mon]
      end # contract_month

      def contract_year
        contract_date.year
      end # contract_year

      def declared_value

        return @declared_value unless @declared_value.nil?

        @declared_value = self.items.inject(0) { |sum, el|
          sum += ((el[:declared_value] || el["declared_value"]).try(:to_i) || 0)
        }
        @declared_value

      end # declared_value

      def items

        return @items if @items.is_a?(Array)
        return (@items = ::JSON.parse(@items.gsub("=>", ":"))) if @items.is_a?(String) && !@items.blank?
        []

      end # items

      private

      def prepare_val(val)
        String(val).sub(/\A\s+/, "").sub(/\s+\z/, "").gsub(/(\s){2,}/, '\\1')
      end # prepare_val

      def set_defaults_if_empty

        ::Cdek::AcceptanceReport::Base::DEFAULTS.each do |name, value|

          if self.respond_to?(name) && send(name).blank?

            method = "#{name}=".to_sym
            send(method, prepare_val(value.call) ) if self.respond_to?(method)

          end # if

        end # each

        self

      end # set_defaults_if_empty

      def validate_items

        if self.items.empty?
          self.errors.add(:items, "Укажите заказы")
          return false
        end
        true

      end # validate_items

    end # Base

  end # AcceptanceReport

end # Cdek
