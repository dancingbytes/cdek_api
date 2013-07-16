# encoding: utf-8
namespace :cdek do

  desc "Загрузка списка городов из xls-файла"
  task :import_cities => :environment do

    ::CdekApi::Import.new(
      ::File.expand_path('../../../tmp/cities.xls', __FILE__),
      ::File.expand_path('../../../lib/cdek_api/cities.rb', __FILE__),
    ).save

  end # import_cities

end # :cdek

# bundle exec rake cdek:import_cities
