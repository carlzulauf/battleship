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

puts
loop do
  # puts win_counts.inspect if i % 10 == 0
  players = player_classes.map{ |klass| klass.new }
  game = Battleship::Game.new(10, [2, 3, 3, 4, 5], *players)
  game.tick until game.winner
  win_counts[game.winner.name] += 1
  (winner, score1), (loser, score2) = win_counts.sort_by{ |name, c| c * -1 }
  if score1 && score2
    lead = (score1 - score2).to_s.rjust(8)
    lead += "  (#{score1.to_s.rjust(8)} to #{score2.to_s.rjust(8)})"
    name_size = [winner.length, loser.length].max
    if score1 == score2
      print "\r#{'Tied'.ljust(name_size)}        #{lead}"
    else
      print "\r#{winner.ljust(name_size)} up by: #{lead}"
    end
    break if score1 - score2 == 100
  end
end

puts
puts win_counts.inspect
