# encoding: utf-8
namespace :cdek do

  desc "Загрузка списка городов из xls-файла"
  task :import_cities => :environment do

    ::CdekApi::Import.new(
      ::File.expand_path('../../../tmp/cities.xls', __FILE__),
      ::File.expand_path('../../../lib/cdek_api/cities.rb', __FILE__),
    ).save

  end # import_cities

  desc "Загрузка списка городов доставки в базу сайта"
  task :install => :environment do

    puts
    puts "Clear cdek deliveries... "
    ::Delivery.where(:delivery_type_id  => ::CdekApi::UUID).with(safe: true).delete_all
    puts "Ok"

    ext_deliveries = [

      # EMS
      {
        delivery_type_id: "4f86e26e8a67ad5f0f000006",
        price:  "расчитывается",
        time:   "5 - 14 дней",
        description: "Почта EMS является дорогим, но относительно быстрым способом доставки. Средняя стоимость варьируется от 800 до 2000 рублей. Вы можете рассчитать приблизительную стоимость доставки, воспользовавшись калькулятором на сайте <a href=\"http://www.emspost.ru/ru/calc/\">Почты EMS</a>. Выберите Челябинскую область в качестве пункта отправления и вес заказа.",
        position: 10
      }, {
        # Почта России
        delivery_type_id: "4f86e26e8a67ad5f0f00000b",
        price:  "от 200 руб.",
        time:   "1 – 3 недели",
        description: "Мы хорошо упакуем ваш заказ, вложим накладную, все необходимые инструкции и отправим Почтой России. Если необходимо, вы можете выбрать &laquo;Наложенный платёж&raquo; &mdash; в данном случае оплата будет производиться на месте, в вашем местном почтовом отделении. Минус данного способа оплаты &mdash; дополнительная комиссия, которую взимает Почта России в размере нескольких процентов. Из плюсов &mdash; широкая география отделений по всей стране.",
        position: 11
      }, {
        # Почта России 1 класс
        delivery_type_id: "5100ed648a67adc7f1000026",
        price:  "от 250 руб.",
        time:   "1 – 3 недели",
        description: "<span style=\"font-weight: bold;\">Максимальный вес посылки 2 кг.</span><br />Мы хорошо упакуем ваш заказ, вложим накладную, все необходимые инструкции и отправим Почтой России. Если необходимо, вы можете выбрать &laquo;Наложенный платёж&raquo; &mdash; в данном случае оплата будет производиться на месте, в вашем местном почтовом отделении. Минус данного способа оплаты &mdash; дополнительная комиссия, которую взимает Почта России в размере нескольких процентов. Из плюсов &mdash; широкая география отделений по всей стране.",
        position: 12
      }

    ]

    puts "Insert cdek deliveries... "
    ::CdekApi::Delivery.codes.each do |key, values|

      descr = ""
      unless values[:courier]

        descr << "<span style=\"font-weight: bold;\">Адрес:</span> #{values[:address]}<br />"
        descr << "<span style=\"font-weight: bold;\">Телефон:</span> #{values[:phone]}<br />"       unless values[:phone].blank?
        descr << "<span style=\"font-weight: bold;\">График работы:</span> #{values[:work_time]}"   unless values[:work_time].blank?

      else
        descr = "Доставка курьером до двери."
      end

      b  = values[:cost]

      r, d, a, v = key.split('-')

      dv = ::Delivery.new

      dv.region_code      = r
      dv.district_code    = d
      dv.area_code        = a
      dv.village_code     = v
      dv.location         = "test"

      dv.delivery_type_id = ::CdekApi::UUID
      dv.price            = "от #{b} руб."
      dv.time             = "#{values[:delivery]} дней"
      dv.description      = descr
      dv.position         = 0

      unless dv.with(safe: true).save
        puts "key: #{key}, r: #{r}, d: #{d}, a: #{a}, v: #{v}."
        puts dv.errors.inspect
        throw "ERROR"
      end

      count = Delivery.
        where({
          region_code:    r,
          district_code:  d,
          area_code:      a,
          village_code:   v,
          :delivery_type_id.in => [
            "4f86e26e8a67ad5f0f00000b",
            "5100ed648a67adc7f1000026",
            "4f86e26e8a67ad5f0f000006"
          ]
        }).count

      if count == 0

        ext_deliveries.each do |hash|

          dv = ::Delivery.new

          dv.region_code      = r
          dv.district_code    = d
          dv.area_code        = a
          dv.village_code     = v
          dv.location         = "test"

          dv.delivery_type_id = hash[:delivery_type_id]
          dv.price            = hash[:price]
          dv.time             = hash[:time]
          dv.description      = hash[:description]
          dv.position         = hash[:position]

          unless dv.with(safe: true).save
            puts "key: #{key}, r: #{r}, d: #{d}, a: #{a}, v: #{v}."
            puts dv.errors.inspect
            throw "ERROR"
          end

        end # each

      end # if

    end # each

    Rake::Task["anlas:order_deliveries"].invoke

    puts "Ok"

  end # :install

end # :cdek

# bundle exec rake cdek:import_cities
# bundle exec rake cdek:install
