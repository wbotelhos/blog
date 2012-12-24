class Donator < ActiveRecord::Base
  attr_accessible :name, :email, :url, :amount, :about, :country, :message

  default_scope order 'created_at desc'

  validates :email,   presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :name,    presence: true
  validates :amount,  presence: true, numericality: true

  def plan
    if amount <= 10
      'Tiny'
    elsif amount > 10 && amount <= 20
      'Small'
    elsif amount > 20 && amount <= 30
      'Medium'
    elsif amount > 30 && amount <= 50
      'Big'
    else
      'Huge'
    end
  end
end
