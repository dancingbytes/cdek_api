# encoding: utf-8
module CdekApi

  class Delivery

    class << self

      def codes
        ::CdekApi::Cities::CODES
      end # codes

    end # class << self

    def initialize(order)

      @order   = order
      @table   = self.class.codes[ city_format(order.city) ] || {}
      @tariff  = calculate_tariff(order.weight, order.length, order.width, order.height)

    end # initialize

    def cost

      return 0      unless self.valid?
      return @cost  unless @cost.nil?

      @cost = 0

      unless @order.payed?
        @cost += (@order.basket_price * 0.04)
      end

      @cost += ((@tariff + self.additional_cost) * 1.04)
      @cost += (@order.package_price * 1.1)
      @cost

    end # cost

    def cost_base

      return 0            unless self.valid?
      return @cost_base   unless @cost_base.nil?

      @cost_base = @tariff
      @cost_base

    end # cost_base

    def reward

      return 0        unless self.valid?
      return @reward  unless @reward.nil?

      @reward = 0

      unless @order.payed?
        @reward += (@order.basket_price * 0.0375)
      end

      @reward += (@tariff * 1.0375)
      @reward += self.additional_cost
      @reward

    end # reward

    def reward_return

      return 0          unless self.valid?
      return @reward_r  unless @reward_r.nil?

      @reward_r = 0

      unless @order.payed?
        @reward_r += (@order.basket_price * 0.0375)
      end

      @reward_r += (@tariff * 1.0375)
      @reward_r += self.additional_cost
      @reward_r

    end # reward_return

    # Доп. расходы
    def additional_cost
      (@table[:courier] == true ? 19 : 0)
    end # additional_cost

    def valid?
      !@tariff.nil?
    end # valid?

    def city_id
      @table[:code]
    end # city_id

    def tariff_id
      @table[:tariff]
    end # tariff_id

    private

    def city_format(city)

      [
        city.region_code,
        city.district_code,
        city.area_code,
        city.village_code
      ].join('-')

    end # city_format

    def calculate_tariff(weight, length, width, height)

      res, data = ::CdekApi.calculate({

        :receiver_city_id => self.city_id,
        :tariff_id        => self.tariff_id,
        :goods => [{
          weight: weight,
          length: length,
          width:  width,
          height: height
        }]

      })

      return datas["price"] if res

      data.each do |err|
        @order.errors.add(:weight, " &mdash #{err.message}")
      end
      return 0

    end # calculate_tariff

  end # Delivery

end # CdekApi
