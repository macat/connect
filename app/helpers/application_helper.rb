module ApplicationHelper
  def link_to_namely(subdomain, *args)
    link_to "#{ subdomain }.namely.com", "https://#{ subdomain }.namely.com", *args
  end
end
