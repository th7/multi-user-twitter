class User < ActiveRecord::Base
  def twitter
    @twitter ||= Twitter::Client.new(oauth_token: self.oauth_token, oauth_token_secret: self.oauth_secret)
  end
end
