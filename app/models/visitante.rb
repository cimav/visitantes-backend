class Visitante < ApplicationRecord

  has_many :visitas

  mount_base64_uploader :avatar, AvatarUploader


  def convert_from_base64(image_data)
    data = StringIO.new(Base64.decode64(image_data))
    data.class.class_eval { attr_accessor :original_filename, :content_type }

    tmp = Tempfile.new("base64")
    tmp.write(data.read)
    tmp.close

    # only on *nix
    data.content_type = IO.popen(["file", "--brief", "--mime-type",tmp.path],in: :close, err: :close).read.chomp
    data.original_filename = "picture." + data.content_type.split("/").last

    data
  end

end
