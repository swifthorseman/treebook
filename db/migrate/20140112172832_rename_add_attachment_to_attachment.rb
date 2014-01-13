class RenameAddAttachmentToAttachment < ActiveRecord::Migration
  def change

    change_table :documents do |t|
      t.rename :add_attachment_file_name, :attachment_file_name
      t.rename :add_attachment_content_type, :attachment_content_type
      t.rename :add_attachment_file_size, :attachment_file_size
      t.rename :add_attachment_updated_at, :attachment_updated_at
    end

  end
end
