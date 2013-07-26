# encoding: utf-8
require 'spreadsheet'

module CdekApi

  class Import

    def initialize(from, to, client_encoding = 'UTF-8')

      @from = from
      @to   = to
      ::Spreadsheet.client_encoding = client_encoding

    end # new

    def save

      book   = ::Spreadsheet.open @from
      sheet1 = book.worksheet 0

      not_found = 0
      total     = 0
      tmp       = {}

      save_to_file do |file|

        sheet1.each do |row|

          code      = row[0]
          city_name = row[1]
          postcode  = String(row[5] || "").split(",")[0]

          city      = get_city(postcode, city_name)

          total     += 1


          if !city
            not_found += 1
            puts "Not found: [#{code}] #{city_name} -> #{postcode}"
          elsif !tmp[code].nil?
            not_found += 1
            puts "Dublicate: [#{code}] #{city_name} -> #{postcode}"
          else

            tmp[code] = true

            result, data = ::CdekApi.api.pvz_list(code)

            if result

              data        = data[0] || {}
              address     = data[:address]
              phone       = data[:phone]
              work_time   = data[:work_time]

            else

              address     = ""
              phone       = ""
              work_time   = ""

            end

            data = ::CdekApi.best_tariff(code)

            if data

              tariff   = data[:tariff] || 0
              delivery = "#{data[:min]} - #{data[:max]}"
              cost     = data[:price] || 0
              courier  = data[:courier] == true

              file.write("      # #{city.name}\n")
              file.write("      '#{city.region_code}-#{city.district_code}-#{city.area_code}-#{city.village_code}' => {\n\n")
              file.write("        code:       #{code},\n")
              file.write("        tariff:     #{tariff},\n")
              file.write("        address:    '#{address}',\n")
              file.write("        phone:      '#{phone}',\n")
              file.write("        work_time:  '#{work_time}',\n")
              file.write("        delivery:   '#{delivery}',\n")
              file.write("        courier:    #{courier},\n")
              file.write("        cost:       #{cost}\n\n")
              file.write("      },\n\n")

            end # if

          end # if

        end # each

        file.seek(-10, IO::SEEK_END)
        file.write("      }\n\n")

      end # save_to_file

      puts "total: #{total}, not found: #{not_found}"

      true

    end # save

    private

    def get_city(postcode, city_name)

      city = ::Area.search_city(postcode).first
      return city if city

      name, region = city_name.split(",")
      if region.blank?
        ::Area.search_city(name).first
      else

        region = region.split(" ")[0]
        ::Area.search_city("#{name}, #{region}").first

      end

    end # get_city

    def save_to_file

      ::File.open(@to, "wb") { |file|

        file.write("# encoding: utf-8\n")

        file.write("module CdekApi\n\n")

        file.write("  module Cities\n\n")

        file.write("    CODES = {\n\n")

          yield(file)

        file.write("    }.freeze\n\n")

        file.write("  end # Cities\n\n")

        file.write("end # CdekApi\n")

      }
      self

    end # save_to_file

  end # Import

end # CdekApi
