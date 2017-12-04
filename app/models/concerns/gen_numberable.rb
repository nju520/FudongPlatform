module GenNumberable
  extend ActiveSupport::Concern

  private
  def gen_no(column, method, len)
    self.write_attribute(column, RandomCode.send(method, len))
  end
end
