class Admin < ApplicationRecord
  attr_accessor :remember_token

  validates :first_name, presence: true, length: {maximum: 100}
  validates :last_name, presence: true, length: {maximum: 100}
  validates :password, length: {minimum: 8}, allow_blank: true
  VALID_NUMBER_REGEX = /(^(?!\+.*\(.*\).*\-\-.*$)(?!\+.*\(.*\).*\-$)(\+[0-9]{3,5}([-0-9]{0,8})?([0-9]{0,3})?)$)|(^[0-9]{1,4}$)/
  validates :phone_number, length: {maximum: 30},
            format: { with: VALID_NUMBER_REGEX}
  has_secure_password

  def Admin.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
             BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Admin.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = Admin.new_token
    update_attribute(:remember_digest,
                     Admin.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest,nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

end
