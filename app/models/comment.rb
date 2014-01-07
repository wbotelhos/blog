class Comment < ActiveRecord::Base
  include ActsAsTree
  extend ActsAsTree::Presentation

  attr_accessible :body, :email, :name, :parent_id, :url

  belongs_to :commentable, polymorphic: true

  scope :pendings , -> { where pending: true, author: false  }
  scope :roots    , -> { where parent_id: nil }

  acts_as_tree order: 'id desc'

  validates :body, :commentable, :name, presence: true
  validates :email,                     presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
end
