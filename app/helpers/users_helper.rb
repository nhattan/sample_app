module UsersHelper
	# Return the Gravater for given user
	def gravatar_for(user, options = { size: 40 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	end
end
