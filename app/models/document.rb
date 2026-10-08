# == Schema Information
#
# Table name: documents
#
#  id                   :uuid             not null, primary key
#  name                 :string
#  path                 :string           not null
#  public               :boolean          default(FALSE)
#  variations           :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  document_category_id :string
#  language_id          :string
#
class Document < ApplicationRecord
  belongs_to :document_category, optional: true
  alias_method :category, :document_category
  alias_method :category=, :document_category=

  has_many :cdn_files, dependent: :destroy
  alias_method :files, :cdn_files
  alias_method :files=, :cdn_files=

  has_many :product_documents, dependent: :destroy
  has_many :products, through: :product_documents, source: :product

  after_update :rename_path, if: -> { saved_change_to_name? || saved_change_to_document_category_id? }
  after_update :rename_files, if: :saved_change_to_path?

  def sync_variations
    return if files.nil?
    return if files.none?

    # documents/products/Flexsol-903/TD-Flexsol-903-EN.pdf
    # documents/products/Flexsol-903/TD-Flexsol-903-DE.pdf
    # documents/products/Flexsol-903/TD-Flexsol-903-FR.pdf
    paths = files.map(&:path)

    # TD-Flexsol-903-EN.pdf
    # TD-Flexsol-903-DE.pdf
    # TD-Flexsol-903-FR.pdf
    file_names = paths.map { |p| p.split('/').last }

    # EN.pdf
    # DE.pdf
    # FR.pdf
    extensions = file_names.map { |p| p.split('-').last }

    # EN.pdf,DE.pdf,FR.pdf
    update!(variations: extensions.join(','))
  end

  private

  def rename_path
    log.info "ℹ️ name changed to: #{name}"

    return if category.nil?

    file_name = url_safe(name)
    new_path = "documents/#{category.slug}/#{file_name}"

    log.info "ℹ️ changing path to: #{new_path}"

    update!(path: new_path)

    log.info "✅ done"
  end

  def rename_files
    log.info "ℹ️ path changed to: #{path}"

    return if files.nil?
    return if files.none?

    log.info "ℹ️ renaming CDN files..."

    files.each do |f|
      f.rename(to: path)
    end

    log.info "✅ done"
  end

  def url_safe(str)
    str.gsub(/[^a-zA-Z0-9\s-]/, '').gsub(/\s+/, '-').gsub(/\-+/, '-').strip
  end
end
