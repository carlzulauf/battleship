$:.unshift File.expand_path("../../lib", __FILE__)
$:.unshift File.expand_path("../../players/lib", __FILE__)
$:.unshift File.expand_path("../../contestants/lib", __FILE__)
$:.unshift File.expand_path("../../data", __FILE__)

require "battleship/game"
require "battleship/util"

load ARGV[0]
load ARGV[1]

player_classes = Battleship::Util.find_player_classes
win_counts = {}.tap{ |c| player_classes.each{ |klass| c[klass.new.name] = 0 } }

loop do
  players = player_classes.map{ |klass| klass.new }
  game = Battleship::Game.new(10, [2, 3, 3, 4, 5], *players)
  game.tick until game.winner
  win_counts[game.winner.name] += 1
  diff = win_counts.values.reduce(:-).abs
  print "\r#{win_counts.inspect} (#{diff.to_s.rjust(3)} game lead)"
  break if diff >= 100
  players.reverse!
end

puts
