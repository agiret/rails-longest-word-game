require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times.map do |i|
      @letters << ("a".."z").to_a.sample.upcase
    end
    @letters = @letters.join
    @start_time = Time.now
  end

  def score
    # raise
    puts params[:word]
    puts params[:grid]
    @score = run_game(params[:word], params[:grid], params[:start_time])
  end

  private

  def run_game(attempt, grid, start_time)
    # TODO: runs the game and return detailed hash of result
    result = {}
    puts start_time
    start_time = Time.parse(start_time)
    end_time = Time.now
    result[:time] = end_time - start_time
    if valid_word?(attempt)
      valid_letters?(attempt, grid) ? result[:score] = attempt.size.to_f / result[:time] : result[:score] = 0
      # if valid_letters?(attempt, grid)
      #   result[:score] = attempt.size.to_f / result[:time]
      # else
      #   result[:score] = 0
      # end
    else
      result[:score] = 0
    end
    result[:message] = the_message(attempt, grid)
    result
  end

  def the_message(attempt, grid)
    if valid_word?(attempt)
      mess = "Mot dans le dico"
      valid_letters?(attempt, grid) ? mess = "well done" : mess = "not in the grid"
    else
      mess = "not an english word"
    end
    mess
  end

  def valid_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    word["found"]
  end

  def valid_letters?(attempt, grid)
    h_attempt = attempt.upcase.chars.group_by { |letter| letter }.map { |k, v| [k, v.size] }.to_h
    h_grid = grid.split("").group_by { |letter| letter }.map { |k, v| [k, v.size] }.to_h
    r = false
    p "-----"
    p h_grid
    p "------"
    h_attempt.each_key do |letter|
      if h_grid[letter]
        h_grid[letter] >= h_attempt[letter] ? r = true : break
      else
        break
      end
    end
    return r
  end
end
