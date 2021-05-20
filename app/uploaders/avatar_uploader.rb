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
    ActionController::Base.helpers.asset_path('fallback/' + ['default.png'].compact.join('_'))
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

  def content_type_allowlist
    [%r{image/}]
  end

  # Override the filename of the uploaded files
  def filename
    "#{model.username.to_s.underscore}.#{file.extension}" if original_filename.present?
  end

  # validate content type of image before processing it
  def validate(file)
    image = MiniMagick::Image.open(file.path)
  rescue StandardError
    raise CarrierWave::IntegrityError, I18n.translate(:"errors.messages.content_type_whitelist_error", content_type: content_type,
                                                                                                       allowed_types: Array(content_type_allowlist).join(', '), default: :"errors.messages.content_type_allowlist_error")
  end
end
