require 'sinatra'
require './sudoku.rb'

get '/' do
  erb :index
end

post '/solve' do
	s = Sudoku.new
	("a".."i").each do |block|
		(1..9).each do |cell|
			value = params[block + cell.to_s]
			if value != ""
				s.insert(block.to_sym,cell,value)
			end
		end
	end
  s.solve
  s.raw
end
