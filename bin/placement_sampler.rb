$:.unshift File.expand_path("../../lib", __FILE__)
$:.unshift File.expand_path("../../players/lib", __FILE__)
$:.unshift File.expand_path("../../contestants/lib", __FILE__)
$:.unshift File.expand_path("../../data", __FILE__)

require "pry"
require "battleship/util"
require "bender"

path = ARGV[0]
load ARGV[0]

player_class = Battleship::Util.find_player_classes.first

placements = 1000.times.map{ player_class.new.new_game }
File.open("contestants/lib/bender/game_history.rb", "w") do |file|
  file.write("module Bender\n  def self.game_history\n    [\n")
  placements.each do |board|
    file.write("      #{board.inspect},\n")
  end
  file.write("    ]\n  end\nend\n")
end

# binding.pry

load "contestants/lib/bender/game_history.rb"

clean_board = (0..9).map{ |y| (0..9).map{ :unknown } }
bender = Bender::Game.new([:HistoryBonus])
bender.update(clean_board, [5,4,3,3,2])
bender.run_scores
puts bender.board.inspect
