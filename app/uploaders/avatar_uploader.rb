class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  before :process, :validate

  # Directory where uploaded files will be stored.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded
  def default_url(*_args)
    ActionController::Base.helpers.asset_path("fallback/#{['default.png'].compact.join('_')}")
  end

  # All uploads will be resized to 400x400
  process resize_to_fit: [400, 400]

  # creates smaller version of the uploaded pic
  version :medium do
    process resize_to_fit: [200, 200]
  end

  # Allowlist of extensions which are allowed to be uploaded.
  def extension_allowlist
    %w[jpg jpeg png gif]
  end

  # Override the filename of the uploaded files
  def filename
    "#{model.username.to_s.underscore}.#{file.extension}" if original_filename.present?
  end

  # validate content type of image before processing it
  def validate(file)
    unless file_is_image(file.path)
      StandardError
      raise CarrierWave::IntegrityError, I18n.translate(:"errors.messages.content_type_whitelist_error", content_type: content_type,
                                                                                                         allowed_types: Array(content_type_allowlist).join(', '), default: :"errors.messages.content_type_allowlist_error")
    end
  end

  # list of valid signatures for this uploader
  VALID_IMAGE_SIGNATURES = [
    "\x89PNG\r\n\x1A\n".force_encoding(Encoding::ASCII_8BIT), # PNG
    'GIF87a'.force_encoding(Encoding::ASCII_8BIT), # GIF87
    'GIF89a'.force_encoding(Encoding::ASCII_8BIT), # GIF89
    "\xFF\xD8".force_encoding(Encoding::ASCII_8BIT) # JPEG/JPG
  ].freeze

  # read first 8 bytes of file and check if it's a valid signature
  def file_is_image(temporary_file_path)
    return false unless temporary_file_path

    file_stream = File.new(temporary_file_path, 'r')
    first_eight_bytes = file_stream.readpartial(8)
    file_stream.close

    VALID_IMAGE_SIGNATURES.each do |signature|
      return true if first_eight_bytes.start_with?(signature)
    end

    false
  end
end
