class Sudoku
  attr_accessor :blocks
  def initialize
    @blocks = {}
    for i in (:a..:i)
      @blocks[i] = SudokuBlock.new
    end
    return nil
  end

  def insert(bidx,cidx,val)
    blocks[bidx].cells[cidx].set_single(val.to_i)
  end

  def solve
    @blocks.values.each do |block|
      block.update_singles
    end
    changed = true
    while changed
      changed = false
      (1..3).each do |oidx|
        (1..3).each do |iidx|
          #puts oidx.to_s + " " + iidx.to_s
          row_sing = get_singles(get_row(oidx,iidx))
          puts row_sing.to_s + " for " + oidx.to_s+":"+iidx.to_s
          col_sing = get_singles(get_col(oidx,iidx))
          row_sing.each do |s|
            get_row(oidx,iidx).each do |cell|
              if cell.remaining > 1
                puts "removing " + s.to_s + " from " + cell.possibilities.to_s + " in " + oidx.to_s+":"+iidx.to_s
                cell.rem_used s
                changed = true
              end
            end
          end
          col_sing.each do |s|
            get_col(oidx,iidx).each do |cell|
              if cell.remaining > 1
                cell.rem_used s
                changed = true
              end
            end
          end
        end
      end
    end
  end
  
  def get_singles(coll)
    singles = []
    coll.each do |a|
      if a.remaining == 1
        #puts a.class.to_s + " " + a.to_s
        singles.push a.possibilities[0]
      end
    end
    return singles
  end

  def get_row(ridx,cidx)
    row = []
    @blocks.values.each_with_index do |block,idx|
      if ((idx+1).to_f / 3.to_f).ceil == ridx  
        row += block.get_row(cidx)
      end
    end
    return row
  end 
  
  def get_col(idx,cidx)
    col = []
    (0..2).each do |mult|
      #puts " " + mult.to_s
      col += @blocks.values[mult * 3 + idx - 1].get_col cidx
    end
    return col
  end

  def get_cell(block,id)
    @blocks[block].cells[id]
  end

  def put_raw
    25.times{ print "-"}
    puts ""
    (1..3).each do |oidx|
      (1..3).each do |iidx|
        print "| "
        get_row(oidx,iidx).each_with_index do |cell,i|
          if cell.remaining == 1
            print cell.possibilities[0].to_s + " "
          else
            print "X "
          end
          if (i+1)%3 == 0
            print "| "
          end
        end
        puts ""
      end
      25.times{ print "-"}
      puts ""
    end

    (:a..:i).each do |block|
      (1..9).each do |cell|
         puts block.to_s + 
                     cell.to_s + 
                     " -> " + 
                     get_cell(block,cell).possibilities.to_s +
                     "\n"
      end
    end
  end

  def raw
    response = """
      <html>
        <head>
        <style type='text/css'>
          body { font-family:monospace; }
        </style>
        </head>
        <body>
      """
    25.times{ response += "-"}
    response += "<br>"
    (1..3).each do |oidx|
      (1..3).each do |iidx|
        response += "| "
        get_row(oidx,iidx).each_with_index do |cell,i|
          if cell.remaining == 1
            response += cell.possibilities[0].to_s + " "
          else
            response += "X "
          end
          if (i+1)%3 == 0
            response += "| "
          end
        end
        response += "<br>"
      end
      25.times{ response += "-"}
      response += "<br>"
    end

    (:a..:i).each do |block|
      (1..9).each do |cell|
         response += block.to_s + 
                     cell.to_s + 
                     " -> " + 
                     get_cell(block,cell).possibilities.to_s +
                     "<br>"
      end
    end
    response += "</body></html>"
    return response
  end
end

class SudokuBlock
  attr_accessor :cells
  def initialize
    @cells = {} 
    for i in 1..9 do
      @cells[i] = SudokuCell.new
    end
  end

  def update_singles
    singles = []

    @cells.each do |idx,cell|
      if cell.remaining == 1
        singles.push cell.possibilities[0]
      end
    end
    singles.each do |s|
      @cells.each do |idx,cell|
        if cell.remaining != 1
          cell.rem_used(s)
        end
      end
    end
  end
 
  def get_row(ridx)
    row = []
    @cells.each do |idx,cell|
      if (idx.to_f / 3.to_f).ceil == ridx  
        row.push cell
      end
    end
    return row
  end 
  
  def get_col(idx)
    col = []
    (0..2).each do |mult|
      col.push @cells[mult * 3 + idx]
    end
    return col
  end
 
  def get_open
   open = []
   @cells.each do |idx,cell|
     if cell.remaining != 1 
       open.push idx
     end
   end
   return open
  end
 
  def get_cells
   @cells.each do |idx, cell|
     puts cell.class.to_s + " -> " + cell.to_s + " " + idx.to_s
   end
   return ""
  end
end

class SudokuCell

  attr_accessor :possibilities

  def initialize  
    @possibilities = (1..9).to_a
  end
  
  def rem_used(number)
    @possibilities.delete(number) 
  end
  
  def set_single(value)
    @possibilities.clear.push(value) 
  end
  
  def remaining()
    @possibilities.length
  end
  
end

