class Comment < ActiveRecord::Base
  include ActsAsTree
  extend ActsAsTree::Presentation

  attr_accessible :article_id, :body, :email, :name, :parent_id, :url

  belongs_to :article

  scope :roots, -> { where parent_id: nil }

  acts_as_tree order: 'id desc'

  validates :article, :body, :name, presence: true
  validates :email,                 presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
end
