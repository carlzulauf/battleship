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

stats = Hash.new(0)
sample_size = 10_000
sample_size.times do
  player_class.new.new_game.each do |ship_info|
    ship = Bender::Ship.new(*ship_info)
    ship.points.each do |xy|
      stats[xy] += 1
    end
  end
end

stats.each_pair{ |xy, score| stats[xy] = ( score / sample_size.to_f * 100 ).round }

File.open("contestants/lib/bender/game_stats.rb", "w") do |file|
  file.write("module Bender\n  def self.game_stats\n")
  file.write(stats.pretty_inspect.lines.map{ |l| "    #{l}" }.join)
  file.write("  end\nend\n")
end

# binding.pry

load "contestants/lib/bender/game_history.rb"

clean_board = (0..9).map{ |y| (0..9).map{ :unknown } }
bender = Bender::Game.new("StatBonus" => 1)
bender.update(clean_board, [5,4,3,3,2])
bender.run_scores
puts bender.board.inspect
