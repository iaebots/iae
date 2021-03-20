class MediaUploader < CarrierWave::Uploader::Base
  storage :file

  # define store_dir path so a media_url is created
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
