# == Schema Information
#
# Table name: articles
#
#  id                  :uuid             not null, primary key
#  body                :text
#  date                :date
#  public              :boolean          default(FALSE)
#  slug                :string
#  title               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  article_category_id :uuid
#
# Indexes
#
#  index_articles_on_slug   (slug) UNIQUE
#  index_articles_on_title  (title) UNIQUE
#
class Article < ApplicationRecord
  belongs_to :article_category
  alias_method :category, :article_category
  alias_method :category=, :article_category=
end
