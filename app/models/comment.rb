class Comment < ActiveRecord::Base
  include ActsAsTree
  extend ActsAsTree::Presentation

  attr_readonly :user_id
  attr_accessible :name, :email, :url, :body, :article_id, :parent_id

  belongs_to :article, counter_cache: true
  belongs_to :comment
  # has_many :comments

  scope :roots, -> { where parent_id: nil }#

  acts_as_tree order: 'id desc'#

  validates :name, :body, :article, presence: true
  validates :email,                 presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
end
