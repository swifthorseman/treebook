module ApplicationHelper

  def flash_class(type)
      case type
          when :alert, :error
            "alert-danger"
          when :notice, :success
            "alert-info"
          else
            ""
      end
  end

  def can_display_status?(status)
    signed_in? && !current_user.has_blocked?(status.user) || !signed_in?
  end


  def avatar_profile_link(user, image_options={}, html_options={})
    avatar_url = user.avatar? ? user.avatar.url(:thumb) : nil
    link_to(image_tag(avatar_url, image_options), profile_path(user.profile_name), html_options)
  end


  def status_document_link(status, hr = {:showhr => false})

    if status.document && status.document.attachment?
      content_tag(:span, "Attachment", :class=> "label label-info") + 
        link_to(status.document.attachment_file_name, status.document.attachment.url) + 
        (content_tag(:hr) if hr[:showhr])
    end
  end

end
