# == Schema Information
#
# Table name: images
#
#  alt                  :string
#  caption              :string
#  conversion_error_log :string
#  converting           :boolean
#  original             :string
#  path                 :string           not null, primary key
#  variations           :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  company_id           :uuid
#  user_id              :uuid
#
class Image < ApplicationRecord
  # key :path, String, ID
  # key :original, String
  # key :variations, String
  # key :converting, Boolean
  # key :conversion_error_log, String
  # key :alt, String
  # key :caption, String
  # key :created_at, String
  # key :updated_at, String

  has_many :product_images, dependent: :destroy
  has_many :products, through: :product_images, source: :product

  has_many :person_images, dependent: :destroy
  has_many :people, through: :person_images, source: :person

  belongs_to :company, optional: true
  alias_method :copyright_by, :company
  alias_method :copyright_by=, :company=

  has_many :cdn_files
  alias_method :files, :cdn_files
  alias_method :files=, :cdn_files=

  # The user who uploaded the image.
  belongs_to :user, optional: true

  # Too zealous
  # validates :alt, presence: true, uniqueness: true

  # Videos can have many sizes and file types.
  # This method collects all related CdnFile and concatenates their path endings into 1 string.
  # This string is then stored on Image.variations.
  # def sync_variations
  #   variations = cdn_files.map { |f| f.path.scan('@').any? ? f.path.split('@').last : f.path.split('.').last }.join(',')
  #   update(variations: variations)
  # end

  # Life cycle hooks
  after_create :convert_image
  # after_update :convert_image
  # after_destroy :delete_image

  def convert_image
    ConvertImageJob.perform_later self
  end

  # def delete_image
  #   DeleteImageJob.perform_later self
  # end

  def file_name
    path.split('/').last
  end

  def original_width
    original.split('x').first.gsub('@', '').to_i
  end

  def original_ext
    original.split('.').last
  end

  def ratio
    return nil if original.nil?

    sizes = original.split('.').first.gsub('@', '').split('x')
    width = sizes.first.to_i
    height = sizes.last.to_i
    width.to_f / height
  end
end
