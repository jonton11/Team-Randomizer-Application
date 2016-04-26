# Team Randomizer
require 'sinatra'
require 'sinatra/reloader'
require 'bootstrap-sass'

enable :sessions
# Stretch 2: Use sessions

get '/randomizer' do
  @title = 'Team Randomizer'
  erb :randomizer, layout: :app_layout
end

post '/randomizer' do
  session[:names]  = params[:names]
  session[:choice] = params[:choice]
  session[:number] = params[:number]
  @choice          = params[:choice]
  # Store the parameters into session variables

  number = session[:number].to_i

  random_names = session[:names].split(', ').shuffle
  # Split the entries in the textarea and shuffle into an array

  @error = error_warning

  if session[:choice] == 'Team Count'
    # Team Count
    @names ||= Array.new(number) { [] }
    while random_names.count > 0
      # Iterate through the names array
      number.times do |index|
        # Push all the names into the @names array - this is our final result
        @names[index] << random_names.pop
      end
    end

  else
    # Number Per Team
    @names ||= []
    random_names.each_slice(number) { |entry| @names << entry }
  end
  erb :randomizer, layout: :app_layout
end

def error_warning
  total_names = session[:names].split(', ').count
  number = session[:number].to_i

  if number > total_names
    'Number must be greater than 1 and less than the number of names'
  end
end
