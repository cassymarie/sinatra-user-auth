class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home
  end

  #render the sign-up form view
  get '/registrations/signup' do
    erb :'/registrations/signup'
  end

  #handles the post request ths is sent when the user hits 'submit' on sign-up form
  post '/registrations' do
    @user = User.new(name: params["name"], email: params["email"], password: params["password"])
    # binding.pry
    @user.save
    session[:user_id] = @user.id

    redirect '/users/home'
  end

  #renders the log-in form
  get '/sessions/login' do
    erb :'sessions/login'
  end

  #receives the POST request thats sent when user hits 'submit' on the log-in form
  post '/sessions' do
    @user = User.find_by(email: params[:email], password: params[:password])
    
    if @user
      session[:user_id] = @user.id
      redirect '/users/home'
    end
    redirect '/sessions/login'
  end

  #logs user out by clearing the session hash.
  get '/sessions/logout' do
    session.clear
    redirect '/'
  end

  #renders the user's homepage view
  get '/users/home' do
    @user = User.find(session[:user_id])
    erb :'/users/home'
  end
end
