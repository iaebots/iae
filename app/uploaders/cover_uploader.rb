# frozen_string_literal: true

require 'image_processing/mini_magick'

# Shrine CoverUploader
class CoverUploader < Shrine
  Shrine.plugin :cached_attachment_data
  Shrine.plugin :restore_cached_data

  plugin :determine_mime_type, analyzer: :marcel

  # Override validation helpers translation
  plugin :validation_helpers, default_messages: {
    max_size: ->(max) { I18n.t('errors.file.max_size', max: max / (1024 * 1024)) }, # convert size from B to MB
    min_size: ->(min) { I18n.t('errors.file.min_size', min: min / 1024) }, # convert size from B to KB
    max_width: ->(max) { I18n.t('errors.file.max_width', max: max) },
    min_width: ->(min) { I18n.t('errors.file.min_width', min: min) },
    max_height: ->(max) { I18n.t('errors.file.max_height', max: max) },
    min_height: ->(min) { I18n.t('errors.file.min_height', min: min) },
    max_dimensions: ->(dims) { I18n.t('errors.file.max_dimensions', dims: dims) },
    min_dimensions: ->(dims) { I18n.t('errors.file.min_dimensions', dims: dims) },
    mime_type_inclusion: ->(list) { I18n.t('errors.file.mime_type_inclusion', list: list.join(', ')) },
    mime_type_exclusion: ->(list) { I18n.t('errors.file.mime_type_exclusion', list: list.join(', ')) },
    extension_inclusion: ->(list) { I18n.t('errors.file.extension_inclusion', list: list.join(', ')) },
    extension_exclusion: ->(list) { I18n.t('errors.file.extension_exclusion', list: list.join(', ')) }
  }

  plugin :remove_invalid # remove invalid cached files
  plugin :store_dimensions
  plugin :default_url
  plugin :remove_attachment
  plugin :upload_endpoint if Rails.env.development? || Rails.env.test?

  Attacher.validate do
    validate_min_size 1 * 1024 # 1KB
    validate_max_size 5 * 1024 * 1024 # 10MB
    if validate_mime_type %w[image/jpeg image/png image/webp]
      validate_max_dimensions [5000, 5000]
      validate_min_dimensions [640, 180]
    end
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      cover: magick.resize_to_limit!(1280, 360)
    }
  end
end
