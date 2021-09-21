# frozen_string_literal: true

require 'image_processing/mini_magick'

# Shrine Avatar Uploader
class AvatarUploader < Shrine
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
    validate_min_size 1 * 1024 # 1 KB
    validate_max_size 5 * 1024 * 1024 # 5MB
    validate_extension %w[jpg jpeg png webp gif]
    validate_max_dimensions [5000, 5000] if validate_mime_type %w[image/jpeg image/png image/webp image/gif]
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      small: magick.resize_to_limit!(200, 200),
      medium: magick.resize_to_limit!(400, 400)
    }
  end
end
