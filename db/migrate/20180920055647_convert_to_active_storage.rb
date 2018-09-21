# Dir[Rails.root.join('app/models/**/*.rb')].sort.each do |file|
#   require file
#   # puts file
# end

class ActiveStorageBlob < ActiveRecord::Base
end

class ActiveStorageAttachment < ActiveRecord::Base
  belongs_to :blob, class_name: 'ActiveStorageBlob'
  belongs_to :record, polymorphic: true
end

class ConvertToActiveStorage < ActiveRecord::Migration[5.2]
  require 'open-uri'

  def up
    # # postgres
    # get_blob_id = 'LASTVAL()'
    # # mariadb
    # # get_blob_id = 'LAST_INSERT_ID()'
    # # sqlite
    # # get_blob_id = 'LAST_INSERT_ROWID()'

    # active_storage_blob_statement = ActiveRecord::Base.connection.raw_connection.prepare("active_storage_blob_statement", <<-SQL)
    #   INSERT INTO active_storage_blobs (
    #     key, filename, content_type, metadata, byte_size, checksum, created_at
    #   ) VALUES ($1, $2, $3, '{}', $4, $5, $6)
    # SQL
    # # With the values, SQL was complaining if I didn't have named variables ($1, etc.).

    # active_storage_attachment_statement = ActiveRecord::Base.connection.raw_connection.prepare("active_storage_attachment_statement", <<-SQL)
    #   INSERT INTO active_storage_attachments (
    #     name, record_type, record_id, blob_id, created_at
    #   ) VALUES ($1, $2, $3, #{get_blob_id}, $4)
    # SQL

    # models = ActiveRecord::Base.descendants.reject(&:abstract_class?)

    # transaction do
    #   models.each do |model|
    #     next if ['SaunaList', 
    #     'Booking::AddOrder', 
    #     'UsersSauna', 
    #     'UsersContact', 
    #     'UserOrder', 
    #     'ShotMessagesToken', 'ShotMessage'].include? model.to_s

    #     puts model.to_s
    #     attachments = model.column_names.map do |c|
    #       Regexp.last_match(1) if c =~ /(.+)_file_name$/
    #     end.compact

    #     model.all.each do |instance|
    #       attachments.each do |attachment|
    #         puts instance.send(attachment).url
    #         # puts instance.send(attachment).to_string == '/assets/original/missing.png'
    #         next if instance.send(attachment).url.nil?
    #         puts instance.send(attachment).path

    #         ActiveRecord::Base.connection.raw_connection.exec_prepared(
    #           "active_storage_blob_statement",
    #           [ key(instance, attachment),
    #             instance.send("#{attachment}_file_name"),
    #             instance.send("#{attachment}_content_type"),
    #             instance.send("#{attachment}_file_size"),
    #             checksum(instance.send(attachment)),
    #             instance.updated_at.iso8601
    #           ]
    #         )

    #         ActiveRecord::Base.connection.raw_connection.exec_prepared(
    #           "active_storage_attachment_statement",
    #           [attachment, model.name, instance.id, instance.updated_at.iso8601]
    #         )
    #       end
    #     end
    #   end

    #   ActiveStorageAttachment.find_each do |attachment|
    #     name = attachment.name
      
    #     source = attachment.record.send(name).path
    #     dest_dir = File.join(
    #       "storage",
    #       attachment.blob.key.first(2),
    #       attachment.blob.key.first(4).last(2))
    #     dest = File.join(dest_dir, attachment.blob.key)
      
    #     FileUtils.mkdir_p(dest_dir)
    #     puts "Moving #{source} to #{dest}"
    #     FileUtils.cp(source, dest)
    #   end
    # end

    # # active_storage_attachment_statement.close
    # # active_storage_blob_statement.close
  end

  def down
    execute "DELETE FROM active_storage_blobs;"
    execute "DELETE FROM active_storage_attachments;"
  end

  private

  def key(_instance, _attachment)
    SecureRandom.uuid
    # Alternatively:
    # instance.send("#{attachment}_file_name")
  end

  def checksum(attachment)
    # local files stored on disk:
    url = attachment.path
    puts "Url: #{url}"
    Digest::MD5.base64digest(File.read(url))

    # remote files stored on another person's computer:
    # url = attachment.url
    # Digest::MD5.base64digest(Net::HTTP.get(URI(url)))
  end
end
