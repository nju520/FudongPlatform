class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :password, :password_confirmation

  validates_presence_of :email, message: "邮箱不能为空"
  validates_format_of :email, message: "邮箱格式不合法",
    with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/,
    if: proc { |user| !user.email.blank? }
  validates :email, uniqueness: true

  validates_presence_of :password, message: "密码不能为空",
    if: :need_validate_password
  validates_presence_of :password_confirmation, message: "密码确认不能为空",
    if: :need_validate_password
  validates_confirmation_of :password, message: "密码不一致",
    if: :need_validate_password
  validates_length_of :password, message: "密码最短为6位", minimum: 6,
    if: :need_validate_password

  has_many :addresses, -> { where(address_type: Address::AddressType::User).order("id desc") }

  has_one :buyer_account,  dependent: :destroy
  has_one :seller_account, dependent: :destroy

  belongs_to :default_address, class_name: :Address, optional: true
  has_many :products, foreign_key: 'seller_id', dependent: :destroy
  has_many :orders
  has_many :main_orders
  has_many :pack_orders
  has_many :payments

  after_create :create_account


  def username
    self.email.split('@').first
  end

  private
  def need_validate_password
    self.new_record? ||
      (!self.password.nil? || !self.password_confirmation.nil?)
  end

  def create_account
    if self.is_seller == false && self.is_admin == false
      self.create_buyer_account(name: self.username, balance: 0.0)
    elsif self.is_seller == true && self.is_admin == false
      self.create_seller_account(name: self.username, balance: 0.0)
    end
  end
end
