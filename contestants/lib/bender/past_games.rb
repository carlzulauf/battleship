module Bender
  class PastGames
    attr_reader :game, :remaining, :total
    def initialize(game, options)
      @extended_history = options.fetch(:extended_history, true)
      @game = game
      @remaining = all_games
      @total = @remaining.count
      # @game.log "Loaded #{@remaining.count} past games. Sample: #{@remaining.sample.inspect}"
    end

    def whittle(hits, misses)
      return unless game.strategies.key?("HistoryBonus")
      @remaining.select! do |game|
        hits.all? do |coord|
          game.detect{ |ship| ship.member?(coord) }
        end &&
        misses.none? do |coord|
          game.detect{ |ship| ship.member?(coord) }
        end
      end
      # game.log "Remaining past games whittled down to #{@remaining.count}"
      @remaining
    end

    def game_history
      Bender.game_history || []
    rescue
      []
    end

    def all_games
      games = @extended_history ? game_history : sample_games
      games.map{ |game| game.map{ |ship| Ship.new(*ship) } }
    end

    def sample_games
      [
        [[0, 0, 5, :across], [5, 0, 4, :across], [0, 1, 3, :across], [3, 1, 3, :across], [9, 0, 2, :down]],
        [[0, 0, 5, :across], [6, 2, 4, :across], [3, 6, 3, :down], [7, 8, 3, :across], [4, 6, 2, :across]],
        [[2, 1, 5, :across], [0, 3, 4, :down], [2, 6, 3, :across], [6, 4, 3, :across], [3, 4, 2, :down]],
        [[3, 7, 5, :across], [3, 8, 4, :across], [5, 1, 3, :down], [7, 4, 3, :across], [1, 1, 2, :down]],
        [[2, 5, 5, :across], [5, 7, 4, :across], [5, 0, 3, :down], [2, 2, 3, :across], [2, 3, 2, :down]],
        [[0, 3, 5, :across], [6, 5, 4, :down], [2, 0, 3, :across], [7, 5, 3, :down], [6, 2, 2, :across]],
        [[2, 1, 5, :across], [7, 4, 4, :down], [5, 6, 3, :down], [6, 9, 3, :across], [4, 2, 2, :across]],
        [[4, 2, 5, :down], [7, 3, 4, :down], [7, 0, 3, :across], [3, 3, 3, :down], [0, 7, 2, :across]],
        [[1, 1, 5, :across], [8, 3, 4, :down], [7, 2, 3, :down], [9, 1, 3, :down], [1, 5, 2, :across]],
        [[0, 1, 5, :across], [8, 2, 4, :down], [2, 7, 3, :across], [3, 2, 3, :down], [9, 5, 2, :down]],
        [[1, 3, 5, :down], [2, 7, 4, :across], [5, 2, 3, :down], [6, 1, 3, :down], [8, 8, 2, :down]],
        [[0, 0, 5, :down], [6, 4, 4, :across], [2, 0, 3, :across], [2, 4, 3, :down], [1, 1, 2, :across]],
        [[2, 2, 5, :down], [0, 6, 4, :down], [4, 2, 3, :across], [1, 1, 3, :across], [5, 7, 2, :down]],
        [[2, 4, 5, :down], [4, 2, 4, :across], [9, 4, 3, :down], [4, 5, 3, :across], [8, 5, 2, :down]],
        [[9, 1, 5, :down], [6, 0, 4, :across], [3, 6, 3, :down], [1, 3, 3, :across], [7, 1, 2, :down]],
        [[4, 1, 5, :across], [0, 0, 4, :across], [7, 3, 3, :across], [2, 3, 3, :down], [4, 3, 2, :across]],
        [[2, 3, 5, :across], [3, 7, 4, :across], [5, 8, 3, :across], [2, 5, 3, :down], [7, 5, 2, :down]],
        [[2, 4, 5, :down], [5, 0, 4, :down], [1, 3, 3, :across], [9, 6, 3, :down], [7, 4, 2, :down]],
        [[0, 5, 5, :across], [2, 1, 4, :across], [1, 7, 3, :down], [0, 1, 3, :down], [4, 7, 2, :down]],
        [[0, 4, 5, :across], [4, 0, 4, :down], [9, 7, 3, :down], [9, 3, 3, :down], [6, 4, 2, :across]],
        [[5, 1, 5, :down], [7, 5, 4, :down], [3, 1, 3, :down], [0, 2, 3, :down], [8, 4, 2, :down]],
        [[1, 4, 5, :down], [0, 6, 4, :down], [2, 7, 3, :down], [7, 7, 3, :across], [1, 1, 2, :across]],
        [[0, 1, 5, :down], [1, 2, 4, :down], [9, 5, 3, :down], [2, 8, 3, :across], [4, 5, 2, :down]],
        [[7, 0, 5, :down], [2, 3, 4, :down], [8, 2, 3, :down], [3, 7, 3, :down], [0, 3, 2, :across]],
        [[8, 3, 5, :down], [4, 6, 4, :down], [3, 5, 3, :across], [1, 6, 3, :down], [0, 1, 2, :across]],
        [[9, 3, 5, :down], [4, 4, 4, :across], [3, 0, 3, :down], [8, 5, 3, :down], [2, 5, 2, :across]],
        [[4, 4, 5, :down], [6, 6, 4, :down], [2, 1, 3, :down], [7, 7, 3, :across], [3, 3, 2, :across]],
        [[2, 1, 5, :down], [6, 8, 4, :across], [6, 9, 3, :across], [5, 2, 3, :across], [6, 5, 2, :down]],
        [[6, 1, 5, :down], [1, 8, 4, :across], [5, 4, 3, :down], [0, 7, 3, :across], [8, 9, 2, :across]],
        [[0, 1, 5, :down], [2, 6, 4, :across], [1, 2, 3, :across], [3, 4, 3, :across], [1, 0, 2, :across]],
        [[2, 2, 5, :down], [8, 2, 4, :down], [0, 9, 3, :across], [3, 5, 3, :down], [4, 6, 2, :down]],
        [[6, 0, 5, :down], [5, 4, 4, :down], [3, 1, 3, :across], [8, 1, 3, :down], [2, 8, 2, :across]],
        [[1, 2, 5, :down], [5, 3, 4, :down], [2, 3, 3, :across], [4, 8, 3, :across], [7, 9, 2, :across]],
        [[6, 3, 5, :down], [4, 6, 4, :down], [5, 2, 3, :across], [4, 0, 3, :across], [2, 9, 2, :across]],
        [[8, 4, 5, :down], [6, 1, 4, :down], [5, 1, 3, :down], [9, 7, 3, :down], [9, 3, 2, :down]],
        [[1, 4, 5, :across], [5, 9, 4, :across], [4, 0, 3, :across], [0, 8, 3, :across], [0, 2, 2, :down]],
        [[1, 1, 5, :down], [6, 0, 4, :down], [2, 3, 3, :across], [5, 7, 3, :across], [6, 8, 2, :across]],
        [[0, 4, 5, :across], [0, 0, 4, :down], [1, 3, 3, :across], [7, 4, 3, :across], [5, 5, 2, :down]],
        [[8, 2, 5, :down], [1, 0, 4, :across], [6, 3, 3, :down], [1, 7, 3, :down], [5, 1, 2, :across]],
        [[8, 1, 5, :down], [4, 9, 4, :across], [2, 7, 3, :across], [7, 0, 3, :down], [2, 0, 2, :across]],
        [[2, 5, 5, :across], [1, 9, 4, :across], [3, 7, 3, :across], [0, 4, 3, :across], [9, 5, 2, :down]],
        [[1, 3, 5, :down], [6, 4, 4, :across], [2, 7, 3, :across], [0, 0, 3, :across], [4, 5, 2, :across]],
        [[5, 3, 5, :across], [2, 7, 4, :across], [3, 8, 3, :across], [2, 4, 3, :down], [7, 1, 2, :across]],
        [[1, 5, 5, :across], [6, 2, 4, :across], [6, 4, 3, :down], [2, 8, 3, :across], [1, 3, 2, :down]],
        [[5, 1, 5, :down], [1, 5, 4, :across], [2, 2, 3, :across], [3, 7, 3, :down], [7, 8, 2, :down]],
        [[4, 4, 5, :down], [0, 3, 4, :down], [7, 1, 3, :across], [7, 8, 3, :across], [7, 5, 2, :across]],
        [[2, 8, 5, :across], [5, 2, 4, :across], [8, 6, 3, :down], [3, 1, 3, :across], [8, 5, 2, :across]],
        [[1, 1, 5, :across], [1, 8, 4, :across], [1, 6, 3, :across], [0, 2, 3, :across], [8, 1, 2, :across]],
        [[2, 6, 5, :across], [6, 0, 4, :down], [0, 9, 3, :across], [4, 3, 3, :down], [5, 4, 2, :down]],
        [[3, 8, 5, :across], [5, 0, 4, :down], [3, 9, 3, :across], [8, 4, 3, :down], [6, 9, 2, :across]],
        [[3, 6, 5, :across], [6, 8, 4, :across], [6, 3, 3, :across], [2, 3, 3, :across], [6, 4, 2, :down]],
        [[7, 3, 5, :down], [3, 2, 4, :across], [6, 5, 3, :down], [1, 6, 3, :across], [8, 2, 2, :down]],
        [[2, 0, 5, :across], [0, 1, 4, :down], [1, 3, 3, :down], [7, 1, 3, :down], [3, 6, 2, :down]],
        [[5, 4, 5, :across], [1, 2, 4, :down], [3, 2, 3, :across], [4, 8, 3, :across], [3, 5, 2, :down]],
        [[8, 2, 5, :down], [3, 6, 4, :down], [5, 1, 3, :across], [6, 5, 3, :down], [8, 8, 2, :across]],
        [[4, 1, 5, :across], [5, 2, 4, :down], [4, 5, 3, :down], [1, 8, 3, :across], [7, 3, 2, :across]],
        [[2, 9, 5, :across], [0, 0, 4, :across], [4, 6, 3, :across], [3, 4, 3, :across], [8, 5, 2, :down]],
        [[1, 3, 5, :down], [3, 5, 4, :down], [9, 5, 3, :down], [0, 1, 3, :down], [6, 5, 2, :across]],
        [[0, 7, 5, :across], [0, 5, 4, :across], [0, 6, 3, :across], [9, 0, 3, :down], [1, 2, 2, :down]],
        [[6, 4, 5, :down], [1, 2, 4, :across], [7, 2, 3, :down], [2, 3, 3, :down], [4, 8, 2, :across]],
        [[0, 3, 5, :down], [9, 1, 4, :down], [1, 6, 3, :down], [6, 7, 3, :across], [1, 1, 2, :across]],
        [[3, 0, 5, :across], [4, 8, 4, :across], [9, 1, 3, :down], [8, 2, 3, :down], [9, 8, 2, :down]],
        [[3, 9, 5, :across], [1, 8, 4, :across], [6, 4, 3, :down], [7, 0, 3, :across], [0, 1, 2, :down]],
        [[9, 0, 5, :down], [5, 1, 4, :across], [2, 0, 3, :across], [7, 9, 3, :across], [3, 2, 2, :down]],
        [[1, 1, 5, :across], [3, 7, 4, :across], [0, 0, 3, :across], [7, 8, 3, :across], [6, 9, 2, :across]],
        [[2, 2, 5, :across], [1, 1, 4, :across], [7, 2, 3, :down], [3, 0, 3, :across], [0, 8, 2, :across]],
        [[0, 7, 5, :across], [2, 9, 4, :across], [8, 6, 3, :down], [5, 1, 3, :across], [8, 5, 2, :across]],
        [[0, 5, 5, :across], [0, 6, 4, :down], [7, 7, 3, :down], [7, 0, 3, :across], [1, 0, 2, :down]],
        [[1, 5, 5, :across], [5, 6, 4, :across], [3, 6, 3, :down], [0, 4, 3, :across], [2, 7, 2, :down]],
        [[5, 3, 5, :down], [2, 6, 4, :down], [3, 1, 3, :across], [0, 0, 3, :across], [8, 6, 2, :across]],
        [[2, 3, 5, :down], [2, 0, 4, :across], [1, 6, 3, :down], [4, 7, 3, :across], [4, 9, 2, :across]],
        [[5, 8, 5, :across], [1, 5, 4, :across], [4, 7, 3, :down], [0, 4, 3, :across], [4, 0, 2, :across]],
        [[0, 4, 5, :down], [0, 0, 4, :across], [5, 1, 3, :down], [7, 8, 3, :across], [3, 9, 2, :across]],
        [[1, 5, 5, :down], [4, 0, 4, :down], [6, 0, 3, :across], [2, 2, 3, :down], [8, 1, 2, :across]],
        [[0, 4, 5, :across], [2, 2, 4, :across], [5, 7, 3, :across], [1, 3, 3, :across], [9, 3, 2, :down]],
        [[1, 1, 5, :across], [7, 3, 4, :down], [2, 6, 3, :across], [1, 4, 3, :down], [1, 2, 2, :across]],
        [[0, 3, 5, :across], [5, 1, 4, :across], [7, 5, 3, :across], [9, 0, 3, :down], [6, 9, 2, :across]],
        [[0, 4, 5, :across], [1, 6, 4, :across], [6, 4, 3, :across], [0, 1, 3, :across], [3, 2, 2, :down]],
        [[4, 3, 5, :down], [3, 3, 4, :down], [9, 1, 3, :down], [5, 9, 3, :across], [2, 2, 2, :down]],
        [[1, 3, 5, :down], [3, 6, 4, :across], [3, 2, 3, :down], [7, 6, 3, :across], [5, 9, 2, :across]],
        [[9, 2, 5, :down], [0, 4, 4, :down], [7, 9, 3, :across], [3, 0, 3, :down], [1, 5, 2, :across]],
        [[4, 1, 5, :down], [5, 3, 4, :down], [2, 5, 3, :down], [0, 1, 3, :down], [0, 6, 2, :across]],
        [[1, 1, 5, :down], [2, 4, 4, :across], [4, 6, 3, :across], [8, 3, 3, :down], [0, 9, 2, :across]],
        [[1, 4, 5, :across], [3, 0, 4, :down], [8, 0, 3, :down], [9, 0, 3, :down], [6, 5, 2, :down]],
        [[8, 2, 5, :down], [2, 8, 4, :across], [6, 8, 3, :across], [4, 6, 3, :across], [1, 1, 2, :across]],
        [[0, 2, 5, :down], [3, 0, 4, :across], [3, 5, 3, :down], [2, 2, 3, :across], [1, 9, 2, :across]],
        [[4, 3, 5, :down], [2, 1, 4, :across], [9, 5, 3, :down], [3, 8, 3, :across], [2, 4, 2, :across]],
        [[4, 1, 5, :down], [8, 0, 4, :down], [6, 9, 3, :across], [1, 0, 3, :across], [1, 2, 2, :across]],
        [[5, 2, 5, :across], [2, 5, 4, :across], [4, 8, 3, :across], [7, 4, 3, :across], [1, 4, 2, :across]],
        [[1, 1, 5, :down], [6, 7, 4, :across], [7, 8, 3, :across], [8, 2, 3, :down], [3, 0, 2, :across]],
        [[0, 6, 5, :across], [6, 4, 4, :down], [2, 9, 3, :across], [4, 2, 3, :down], [2, 0, 2, :down]],
        [[3, 7, 5, :across], [9, 2, 4, :down], [1, 1, 3, :down], [1, 5, 3, :across], [4, 4, 2, :down]],
        [[8, 2, 5, :down], [1, 1, 4, :down], [9, 0, 3, :down], [4, 0, 3, :across], [0, 6, 2, :down]],
        [[4, 4, 5, :across], [5, 7, 4, :across], [3, 3, 3, :across], [6, 0, 3, :across], [9, 3, 2, :down]],
        [[8, 0, 5, :down], [1, 7, 4, :across], [9, 7, 3, :down], [4, 0, 3, :down], [3, 9, 2, :across]],
        [[4, 5, 5, :down], [6, 0, 4, :down], [5, 3, 3, :down], [7, 0, 3, :across], [0, 2, 2, :across]],
        [[5, 7, 5, :across], [6, 2, 4, :down], [5, 4, 3, :down], [7, 6, 3, :across], [7, 4, 2, :down]],
        [[3, 4, 5, :down], [1, 0, 4, :across], [1, 1, 3, :down], [7, 9, 3, :across], [6, 4, 2, :down]],
        [[0, 4, 5, :across], [9, 5, 4, :down], [6, 2, 3, :down], [0, 6, 3, :across], [2, 7, 2, :down]],
        [[0, 2, 5, :down], [5, 1, 4, :across], [2, 5, 3, :down], [3, 7, 3, :down], [2, 1, 2, :across]],
        [[5, 0, 5, :down], [7, 2, 4, :down], [1, 6, 3, :across], [1, 0, 3, :down], [2, 7, 2, :down]],
        [[0, 0, 5, :down], [4, 4, 4, :across], [9, 3, 3, :down], [2, 2, 3, :across], [9, 7, 2, :down]],
        [[0, 0, 5, :across], [7, 0, 4, :down], [0, 2, 3, :down], [2, 5, 3, :down], [8, 8, 2, :down]],
        [[1, 1, 5, :down], [6, 1, 3, :across], [2, 3, 3, :across], [4, 4, 2, :down], [6, 3, 4, :down]],
        [[9, 0, 3, :down], [1, 3, 2, :across], [4, 3, 4, :down], [7, 3, 5, :down], [1, 7, 3, :down]],
        [[1, 0, 4, :across], [9, 0, 3, :down], [6, 4, 2, :down], [1, 5, 5, :down], [3, 7, 3, :across]],
        [[0, 0, 4, :down], [1, 4, 5, :across], [0, 5, 3, :down], [1, 8, 2, :across], [4, 8, 3, :across]],
        [[0, 1, 5, :across], [5, 1, 3, :across], [8, 2, 2, :down], [2, 6, 3, :across], [9, 6, 4, :down]],
        [[3, 0, 3, :across], [0, 1, 2, :across], [8, 1, 5, :down], [1, 5, 4, :down], [3, 8, 3, :across]],
        [[2, 1, 3, :across], [6, 1, 2, :across], [1, 3, 5, :across], [7, 4, 4, :down], [2, 6, 3, :across]],
        [[5, 0, 3, :down], [1, 1, 4, :down], [3, 2, 2, :down], [6, 4, 3, :down], [2, 8, 5, :across]]
      ]
    end
  end
end
