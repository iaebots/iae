# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/file_system'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'), # local cache
  store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads') # permanent
}

cache = Shrine.storages[:cache]
cache.clear! { |path| path.mtime < Time.now - 60 * 60 } # delete cached files older than 1 hour

Shrine.plugin :presign_endpoint
Shrine.plugin :pretty_location # provides a good default hierarchy
Shrine.plugin :activerecord # AR integration
Shrine.plugin :derivatives, create_on_promote: true # Save image in multiple versions
Shrine.plugin :backgrounding # Background processing

# Set to process as background job
Shrine::Attacher.promote_block do
  PromoteJob.perform_async(self.class.name, record.class.name, record.id, name, file_data)
end
