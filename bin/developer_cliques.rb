
require_relative '../lib/developer_cliques'

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: developer_cliques.rb [options]"

  opts.on("-f", "--file", "Calculates maximal cliques") do |file|
    options[:maximal_cliques] = file
  end

  opts.on("-h", "--help", "Show this help") do |h|
    options[:help] = h
  end
end.parse!

puts options