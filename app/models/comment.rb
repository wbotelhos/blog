class Comment < ActiveRecord::Base
  include ActsAsTree
  extend ActsAsTree::TreeView

  belongs_to :commentable, polymorphic: true

  scope :pendings, -> { where pending: true, author: false }
  scope :roots,    -> { where parent_id: nil }

  acts_as_tree order: 'id desc'

  validates :body,        presence: true
  validates :commentable, presence: true
  validates :email,       presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :name,        presence: true
end
