require "sinatra"
require "pry"

set :bind, '0.0.0.0'  # bind to all interfaces

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

get '/' do
  if session[:visit_count].nil?
    session[:visit_count] = 1
    session[:computer_score] = 0
    session[:player_score] = 0
  else
    session[:visit_count] += 1
  end
  erb :index
end

post '/' do
  player_choice = params[:choice]
  computer_choice = ["Rock", "Paper", "Scissors"].sample
  if player_choice == "Paper" && computer_choice == "Rock" ||
    player_choice == "Scissors" && computer_choice == "Paper" ||
    player_choice == "Rock" && computer_choice == "Scissors"
    session[:player_score] += 1
    session[:message] = "Player chose #{player_choice}, Computer chose #{computer_choice}. Player wins!"
  elsif computer_choice == "Rock" && player_choice == "Scissors" ||
    computer_choice == "Paper" && player_choice == "Rock" ||
    computer_choice == "Scissors" && player_choice == "Paper"
    session[:computer_score] += 1
    session[:message] = "Player chose #{player_choice}, Computer chose #{computer_choice}. Computer wins!"
  else
    session[:message] = "Player chose #{player_choice}, Computer chose #{computer_choice}. Tie!"
  end
  if session[:player_score] == 3
    session[:game_winner] = "Player wins the game!"
  elsif session[:computer_score] == 3
    session[:game_winner] = "Computer wins the game!"
  else
    session[:game_winner] = nil
  end
  redirect '/'
end

post '/reset' do
  session.clear
  redirect '/'
end
