module Features
  def have_error_message(message)
    have_css("#flash_error", text: message)
  end
end
