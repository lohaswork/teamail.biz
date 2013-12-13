# encoding: utf-8
require 'carrierwave/processing/mime_types'

# Open CarrierWave-Aliyun gem and override put method
module CarrierWave
  module Storage
    class Aliyun < Abstract
      class Connection
        def put(path, file, options = {})
          path = format_path(path)
          bucket_path = get_bucket_path(path)
          content_md5 = Digest::MD5.file(file)
          content_type = options[:content_type] || "image/jpg"
          date = gmtdate
          url = path_to_url(path)
          auth_sign = sign("PUT", bucket_path, content_md5, content_type, date)
          headers = {
            "Authorization" => auth_sign,
            "Content-Type" => content_type,
            "Content-Disposition" => "attachment;filename=\"#{::File.basename file}\"",
            "Content-Length" => file.size,
            "Date" => date,
            "Host" => @aliyun_upload_host,
            "Expect" => "100-Continue"
          }
          RestClient.put(URI.encode(url), file, headers)
          return path_to_url(path, :get => true)
        end
      end
    end
  end
end

class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

  process :set_content_type
  process :save_content_type_size_and_file_name_in_model

  def save_content_type_size_and_file_name_in_model
    model.content_type = file.content_type if file.content_type
    model.name = file.original_filename if file.original_filename
    model.size = file.size if file.size
  end

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}"
    # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 调整临时文件的存放路径，默认是再 public 下面
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def url
    url ||= super({})
    url = url.gsub "http", "https"
    url
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if original_filename
      # current_path 是 Carrierwave 上传过程临时创建的一个文件，有时间标记，所以它将是唯一的
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
  end
end
