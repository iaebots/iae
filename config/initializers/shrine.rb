# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/file_system'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'), # temporary
  store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads') # permanent
}

# delete cached files
file_system = Shrine.storages[:cache]
file_system.clear! { |path| path.mtime < Time.now - 24 * 60 * 60 } # delete files older than 1 day

Shrine.plugin :activerecord # AR integration
Shrine.plugin :derivatives, create_on_promote: true # Save image in multiple versions
Shrine.plugin :backgrounding # Background processing

Shrine::Attacher.promote_block do
  PromoteJob.perform_async(self.class.name, record.class.name, record.id, name, file_data)
end

# Synzchronize all existing carrierwave uploads with Shrine
module CarrierwaveShrineSynchronization
  def self.included(model)
    model.before_save do
      self.class.uploaders.each_key do |name|
        write_shrine_data(name) if changes.key?(name)
      end
    end
  end

  def write_shrine_data(name)
    uploader = send(name)
    attacher = Shrine::Attacher.from_model(self, name)

    if read_attribute(name).present?
      attacher.set shrine_file(uploader)

      uploader.versions.each do |version_name, version|
        attacher.merge_derivatives(version_name => shrine_file(version))
      end
    else
      attacher.set nil
    end
  end

  private

  def shrine_file(uploader)
    name     = uploader.mounted_as
    filename = read_attribute(name)
    location = uploader.store_path(filename)
    location = location.sub(%r{^#{storage.prefix}/}, '') if storage.prefix

    Shrine.uploaded_file(
      storage: :store,
      id: location,
      metadata: { 'filename' => filename }
    )
  end

  def storage
    Shrine.storages[:store]
  end
end
