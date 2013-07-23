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


    puts "Insert cdek deliveries... "
    ::CdekApi::Delivery.codes.each do |key, values|

      descr = ""
      unless values[:address].blank?

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

      unless dv.with(safe: true).save
        puts "key: #{key}, r: #{r}, d: #{d}, a: #{a}, v: #{v}."
        puts dv.errors.inspect
        throw "ERROR"
      end

    end # each

    puts "Ok"

  end # :install

end # :cdek

# bundle exec rake cdek:import_cities
# bundle exec rake cdek:install
