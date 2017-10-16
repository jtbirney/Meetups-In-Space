require 'sinatra'
require 'sinatra/reloader'
require_relative 'config/application'
require 'pry'

set :bind, '0.0.0.0'  # bind to all interfaces

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.order(:id)
  erb :'meetups/index'
end

get '/meetups/:id' do
  @id = params[:id].to_i
  @meetup = Meetup.find(@id)
  @attendees = @meetup.users
  @current = @meetup.user_meetups.find_by(user_id: session[:user_id])
  erb :'meetups/show'
end

get '/create' do
  if !session[:user_id]
    @message = "add a new Meetup."
    erb :'meetups/login'
  else
    erb :'meetups/create'
  end
end

post '/create' do
  @meetup_name = params[:meetup_name]
  @meetup_location = params[:meetup_location]
  @meetup_details = params[:meetup_details]
  meetup = Meetup.new(name: @meetup_name, details: @meetup_details, location: @meetup_location )
  binding.pry
  @errors
  if meetup.valid?
    meetup.save
    current_user = User.find(session[:user_id])
    meetup.users << current_user
    current_user_meetup = meetup.user_meetups.find_by(meetup: meetup)
    current_user_meetup.creator = true
    current_user_meetup.save
    redirect '/meetups'
  else
    @errors = meetup.errors.messages
    erb :'meetups/create'
  end
end

get '/edit-meetup' do
  @id = params[:meetup].to_i
  @meetup = Meetup.find(@id)
  @meetup_name = @meetup.name
  @meetup_location = @meetup.location
  @meetup_details = @meetup.details
  erb :'meetups/update'
end

post '/edit-meetup' do
  @id = params[:meetup].to_i
  @meetup_name = params[:meetup_name]
  @meetup_location = params[:meetup_location]
  @meetup_details = params[:meetup_details]

  @meetup = Meetup.find(@id)
  attributes = {
    name: @meetup_name,
    location: @meetup_location,
    details: @meetup_details
  }
  @meetup.update_attributes(attributes)

  @attendees = @meetup.users
  erb :'meetups/show'
end

post '/delete-meetup' do
  @id = params[:meetup].to_i
  @meetup = Meetup.find(@id)
  @meetup.user_meetups.each do |attendee|
    attendee.destroy
  end
  @meetup.destroy
  redirect '/meetups'
end

post "/add-to-meetup" do
  if session[:user_id]
    @id = session[:user_id]
    @meetup = Meetup.find(params[:meetup])
    user = User.find(@id)
    @message
    if !@meetup.users.include?(user)
      @meetup.users << user
      @message = "You have been added to this meetup"
    end
    @attendees = @meetup.users
    erb :'meetups/show'
  else
    @message = "be added to this meetup."
    erb :'meetups/login'
  end
end

post "/remove-from-meetup" do
  @id = params[:meetup].to_i
  @user = User.find(session[:user_id])
  user_meetup = @user.user_meetups.find_by(meetup_id: @id)
  user_meetup.destroy
  redirect "/meetups/#{@id}"
end
