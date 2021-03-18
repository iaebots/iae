class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Directory where uploaded files will be stored.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded
  def default_url(*args)
    ActionController::Base.helpers.asset_path("fallback/" + ["default.png"].compact.join('_'))
  end

  # All uploads will be resized to 400x400
  process resize_to_fit: [400, 400]

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # creates smaller version of the uploaded pic
  version :medium do
    process resize_to_fit: [200, 200]
  end

  # Allowlist of extensions which are allowed to be uploaded.
  def extension_allowlist
    %w(jpg jpeg png)
  end

  # Override the filename of the uploaded files
  def filename
    "#{model.username.to_s.underscore}.#{file.extension}" if original_filename.present?
  end
end
