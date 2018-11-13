require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (1..10).map { ('A'..'Z').to_a.sample }
  end

  def score
    @score = session[:score]
    session[:score] = 0
    @guess = params[:input]
    @grid = params[:letters].split
    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    attempt_array = @guess.upcase.split('')
    attempt_test = attempt_array.all? { |l| attempt_array.count(l) <= @grid.count(l) }
    if attempt_test == true
      if user['found'] == true
        @score += attempt_array.length
        @result = "Congratulations, #{@guess} is a valid english word"
      else
        @score += 0
        @result = "Sorry, but #{@guess} does not seem to be a valid english word"
      end
    else
      @result = "Sorry, but #{@guess} can´t be built out of #{@grid.join(', ')}"
      @score += 0
    end
    session[:score] += @score
  end
end

