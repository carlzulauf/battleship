$:.unshift File.expand_path("../../lib", __FILE__)
$:.unshift File.expand_path("../../players/lib", __FILE__)
$:.unshift File.expand_path("../../contestants/lib", __FILE__)
$:.unshift File.expand_path("../../data", __FILE__)

require "battleship/game"
require "battleship/util"

load ARGV[0]
load ARGV[1]

win_counts = Hash.new(0)
player_classes = Battleship::Util.find_player_classes

100.times do |i|
  players = player_classes.map{ |klass| klass.new }
  game = Battleship::Game.new(10, [2, 3, 3, 4, 5], *players)
  game.tick until game.winner
  win_counts[game.winner.name] += 1
end

puts win_counts.inspect
