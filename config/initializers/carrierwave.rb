CarrierWave.configure do |config|
  config.permissions = 0766           # drwxrw-rw-
  config.directory_permissions = 0766 # -rwxrw-rw-
  config.storage = :file

  # This avoids uploaded files from saving to public/ and so
  # they will not be available for public (non-authenticated) downloading
  # config.root = Rails.root
end
