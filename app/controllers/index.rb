get '/' do
  @user = User.find(session[:user_id]) if session[:user_id]
  erb :index
end

post '/' do
  @user = User.find(session[:user_id]) if session[:user_id]
  redirect '/' unless @user

  begin
    @user.twitter.update(params[:tweet])
  rescue Twitter::Error => e
    p e
    return 'Tweet failed! -- ' + e.to_s
  end

  'Tweeted: ' + params[:tweet]
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)
  @user = User.find_by_username(@access_token.params[:screen_name])
  if @user
    @user.update_attributes(oauth_token: @access_token.token, oauth_secret: @access_token.secret)
  else
    @user = User.create(id: @access_token.params[:user_id], username: @access_token.params[:screen_name], oauth_token: @access_token.token, oauth_secret: @access_token.secret)
  end
  session[:user_id] = @user.id
  p @user
  # at this point in the code is where you'll need to create your user account and store the access token

  redirect '/'
  # erb :index
  
end
