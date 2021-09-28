# frozen_string_literal: true

require 'image_processing/mini_magick'
require 'streamio-ffmpeg'

# MediaUploader is a polymorphic uploader that accpets images and videos
class MediaUploader < Shrine
  Shrine.plugin :restore_cached_data

  # Contants with permitted image and video mime types
  IMAGE_TYPES = %w[image/jpeg image/jpg image/png image/webp image/gif].freeze
  VIDEO_TYPES = %w[video/mp4].freeze

  plugin :determine_mime_type, analyzer: :marcel
  plugin :validation_helpers
  plugin :remove_invalid # remove invalid cached files
  plugin :store_dimensions
  plugin :remove_attachment
  plugin :upload_endpoint if Rails.env.development? || Rails.env.test?
  plugin :infer_extension, inferrer: :mime_types # add extension to upload without it, based on MIME type

  Attacher.validate do
    validate_mime_type IMAGE_TYPES + VIDEO_TYPES

    case file.mime_type
    when *IMAGE_TYPES
      validate_min_size 1 * 1024 # 1 KB
      validate_max_size 10 * 1024 * 1024 # 10MB
      validate_max_dimensions [5000, 5000]
    when *VIDEO_TYPES
      validate_max_size 5.megabytes # max video size
    end
  end

  Attacher.derivatives do |original|
    # process_derivatives(:image, original) if IMAGE_TYPES.include?(file.mime_type)
    # process_derivatives(:video, original) if VIDEO_TYPES.include?(file.mime_type)
    case file.mime_type
    when *IMAGE_TYPES then process_derivatives(:image, original)
    when *VIDEO_TYPES then process_derivatives(:video, original)
    end
  end

  Attacher.derivatives :image do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      desktop: magick.resize_to_limit!(1200, 670)
    }
  end

  Attacher.derivatives :video do |original|
    transcoded = Tempfile.new ['desktop', '.mp4']
    thumbnail = Tempfile.new ['thumbnail', '.jpg']

    movie = FFMPEG::Movie.new(original.path)
    screenshot_time = (movie.duration / 2).floor

    movie.transcode(transcoded.path)
    movie.screenshot(thumbnail.path, seek_time: screenshot_time)

    { desktop: transcoded, thumbnail: thumbnail }
  end
end
