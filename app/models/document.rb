class Document < ActiveRecord::Base

  has_attached_file :attachment

  before_save :perform_attachment_removal

  attr_accessor :remove_attachment

  def perform_attachment_removal
    if remove_attachment == '1' && !attachment.dirty?
      self.attachment = nil
    end
  end
end
