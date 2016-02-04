require "dotenv"
require "sinatra/base"
require "rack-flash"
require "omniauth"
require "omniauth-mondo"

Dotenv.load

class App < Sinatra::Base
  enable :sessions
  use Rack::Flash

  use OmniAuth::Builder do
    provider :mondo, ENV["MONDO_KEY"], ENV["MONDO_SECRET"], {
      :provider_ignores_state => true
    }
  end

  get "/" do
    erb :index
  end

  get "/auth/mondo/callback" do
    auth = env["omniauth.auth"]
    session[:account_id] = auth[:uid]

    # create a user, and store the oauth tokens for future use and refreshing

    flash[:success] = "Signed in!"
    redirect "/"
  end

  get "/auth/failure" do
    flash[:error] = "Unable to sign in"
    redirect "/"
  end

  get "/auth/signout" do
    session.clear
    flash[:success] = "Signed out!"
    redirect "/"
  end
end
