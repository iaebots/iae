# frozen_string_literal: true

require 'image_processing/mini_magick'

# Shrine CoverUploader
class CoverUploader < Shrine
  Shrine.plugin :cached_attachment_data
  Shrine.plugin :restore_cached_data

  plugin :determine_mime_type, analyzer: :marcel
  plugin :validation_helpers
  plugin :remove_invalid # remove invalid cached files
  plugin :store_dimensions
  plugin :default_url
  plugin :remove_attachment
  plugin :upload_endpoint if Rails.env.development? || Rails.env.test?

  Attacher.validate do
    validate_min_size 1 * 1024 # 1KB
    validate_max_size 15 * 1024 * 1024 # 15MB
    validate_extension %w[jpg jpeg png webp gif]
    if validate_mime_type %w[image/jpeg image/png image/webp image/gif]
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
