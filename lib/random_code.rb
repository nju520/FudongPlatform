module RandomCode
  class << self
    def generate_password len = 8
      seed = (0..9).to_a + ('a'..'z').to_a + ('A'..'Z').to_a + ['!', '@', '#', '$', '%', '.', '*'] * 4
      token = ""
      len.times { |t| token << seed.sample.to_s }
      token
    end

    def generate_utoken len = 8
      a = lambda { rand(36).to_s(36) }
      token = ""
      len.times { |t| token << a.call.to_s }
      token
    end

    def generate_product_uuid len = 6
      Date.today.to_s.split('-')[1..-1].join() << generate_utoken(len).upcase
    end

    def generate_order_uuid len = 5
      Date.today.to_s.split('-').join()[2..-1] << generate_utoken(len).upcase
    end
  end
end
