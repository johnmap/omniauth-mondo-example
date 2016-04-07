require "dotenv"
require "sinatra/base"
require "rack-flash"
require "omniauth"
require "omniauth-mondo"
require_relative "lib/mondo2csv"

Dotenv.load

class App < Sinatra::Base
  enable :sessions
  use Rack::Flash

  use OmniAuth::Builder do
    provider :mondo, ENV["MONDO_KEY"], ENV["MONDO_SECRET"], {
      :provider_ignores_state => true # this is needed because we don't use the state param
                                      # and it'll cause a CSRF error
    }
  end

  get "/" do
    erb :index
  end

  get "/auth/mondo/callback" do
    auth = env["omniauth.auth"]
    
    session[:account_id] = auth[:uid]
    session[:account_name] = auth[:info][:name]
    session[:token] = auth[:credentials][:token]

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
  
  get "/csv/:year/:month" do
    
    date_formatted = params['year'].to_s + '-' + params['month'].to_s
    
    response.headers['Content-Type'] = 'text/csv'
    response.headers['Content-Disposition'] = "attachment; filename=#{date_formatted}mondo2csv.csv"
    
    Mondo2CSV.new(params['year'], params['month'], session[:token]).csv
    
  end
  
end
