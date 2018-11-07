class Article < ApplicationRecord
  extend Enumerize
  paginates_per 10
  validates :entry_at, presence: true
  validates :title, presence: true

  has_many :article_images, dependent: :destroy
  accepts_nested_attributes_for :article_images, allow_destroy: true
  has_many :article_tags, dependent: :destroy
  accepts_nested_attributes_for :article_tags
  has_many :comments, dependent: :destroy
  has_many :like, dependent: :destroy

  enumerize :access_level, in: { public: 0, normal: 1, friend: 2, family: 3 }

  scope :default_order, -> { order(entry_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :accessible, -> (user) { where("access_level <= ?", user.nil? ? 0 : user.access_level_before_type_cast) }

  after_create do
    ArticleImage.link_uploaded_images(self.id)
  end

  def accesible?(user)
    access_level_before_type_cast <= (user.nil? ? 0 : user.access_level_before_type_cast)
  end
end
