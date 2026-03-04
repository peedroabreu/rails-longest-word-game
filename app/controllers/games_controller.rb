require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A" .. "Z").to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters]

    if included?(@word, @letters) && english_word?(@word)
      @result = "Congratulations! #{@word} is a valid English Word!"
    elsif !included?(@word, @letters)
      @result = "Sorry but #{@word} can't be built out of #{@letters}"
    else
      @result = "Sorry but #{@word} does not seem to be a valid English word..."
    end
  end

  private

  def included?(word, letters)
    letters_array = letters.chars

    word.chars.all? do |letter|
      if letters_array.include?(letter)
        letters_array.delete_at(letters_array.index(letter))
        true
      else
        false
      end
    end
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    result = JSON.parse(response)

    result["found"]
  end
end
