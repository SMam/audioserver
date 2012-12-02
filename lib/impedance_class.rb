#!/usr/local/bin/ruby
#  Class Impedance: インピーダンスオージオメータ データ取扱い用クラス
#  Copyright 2012 S Mamiya <MamiyaShn@gmail.com>
#  0.20121102 : initial ver

if defined? Rails
  require 'RS22.rb'
  require 'bitmap.rb'
else
  require './RS22.rb'
  require './bitmap.rb'
end

# railsの場合，directoryの相対表示の起点は rails/audiserv であるようだ

class Impedance < Bitmap
  def initialize(impedancedata)  # 引数は class ImpedanceData のインスタンス
    prepare_font
    if File.exist?(Image_parts_location+"background_tympanogram.png")
      @png = ChunkyPNG::Image.from_file(Image_parts_location +
                                         "background_tympanogram.png")
    else
      @png = ChunkyPNG::Image.new(400,400,WHITE)
      make_tympano_background
      @png.save(Image_parts_location+"background_tympanogram.png", :fast_rgba)
    end
#    if File.exist?(Image_parts_location+"background_reflex.png")
#      @png = ChunkyPNG::Image.from_file(Image_parts_location+"background_reflex.png")
#    else
#      @png = ChunkyPNG::Image.new(400,400,WHITE)
#      make_reflex_background
#      @png.save(Image_parts_location+"background_reflex.png", :fast_rgba)
#    end

    @tympanodata = impedancedata.extract[:tympano]
    @reflexdata = impedancedata.extract[:reflex]
  end

  def make_tympano_background
    [0, 200].each do |offset|
      x1 = 70; x2 = 369; x01 = 169; x02 = 269 
      y1 = 30+offset; y2 = 169+offset; y0 = 149+offset
      line(x1, y1, x1, y2, GRAY, "line")
      line(x2, y1, x2, y2, GRAY, "line")
      line(x1, y1, x2, y1, GRAY, "line")
      line(x1, y2, x2, y2, GRAY, "line")
      line(x01, y1, x01, y2, GRAY, "dot")
      line(x02, y1, x02, y2, GRAY, "line")
      line(x1, y0, x2, y0, GRAY, "line")
      
      put_font( 20, 100+offset-8, ["R", "L"][offset == 0? 0: 1])
      put_font( 49, y1-15-8, "mL")
      put_font( x2-25, y2+15, "daPa")

      l = [["0", 58, y0-8], ["0.5", 42, y0-40-8], ["1.0", 42, y0-80-8], ["1.5", 42, y1-8],
           ["-400", x1-16, y2], ["-200", x01-16, y2], ["0", x02-4, y2], ["200", x2-12 ,y2]]
      l.each do |ll|
        put_string(ll[1], ll[2], ll[0])
      end
    end
  end

  def put_string(x, y, str)
    str.each_byte do |c|
      case c
      when 45                  # if character is "-"
        put_font(x, y, "minus")
      when 46                  # if character is "."
        put_font(x, y, "dot")
      else
        put_font(x, y, "%c" % c)
      end
      x += 8
    end
  end

  def draw_tympanogram
    @tympanodata.each do |t|
      side = (t[:side] == "R")? "R": "L"
      interval = t[:interval]
      pvt = t[:pvt]
      sc = t[:sc]
      peak = t[:peak]
      p_v = [200, 0]
      t[:values].each do |v|
        new_p_v = [p_v[0]-interval, v - pvt]
        draw_line_tympano(p_v, new_p_v, side, "line")
        p_v = new_p_v
      end
#      peak_p_v = [peak, sc]
#      draw_line_tympano(peak_p_v, [200, sc], side, "ref")
#      draw_line_tympano(peak_p_v, [peak, 1.5], side, "ref")
#      sc_round = (sc * 100).round / 100.0
#      put_string(350, 149 + (side == "R"? 0: 200) - (sc * 80).to_i, sc_round.to_s)
    end
  end

  def draw_line_tympano(p_v1, p_v2, side, line)
    color = side == "R"? RED: BLUE
    if line == "ref"
      color = GRAY
      line = "dot"
    end
    offset = side == "R"? 0: 200
    x1 = 269 + p_v1[0]/2 
    y1 = 149 + offset - p_v1[1] * 80
    x2 = 269 + p_v2[0]/2 
    y2 = 149 + offset - p_v2[1] * 80
    line(x1.to_i, y1.to_i, x2.to_i, y2.to_i, color, line)
  end

  def tympano_misc_data
    result = {"R" => {}, "L" => {}}
    @tympanodata.each do |t|
      side = (t[:side] == "R")? "R": "L"
      result[side] = {:pvt => t[:pvt], :sc => t[:sc], :peak => t[:peak]}
    end
    return result
  end

  def pvt
    return {:rt => tympano_misc_data["R"][:pvt], :lt => tympano_misc_data["L"][:pvt]}
  end

  def sc
    return {:rt => tympano_misc_data["R"][:sc], :lt => tympano_misc_data["L"][:sc]}
  end

  def peak
    return {:rt => tympano_misc_data["R"][:peak], :lt => tympano_misc_data["L"][:peak]}
  end

  def dump_png
    dumps = Array.new
    draw_tympanogram
    dumps = {:tympanogram => dump, :reflex => nil}
#    draw_reflexgram
#    dumps[:reflex] = dump
    return dumps
  end

  def draw(tympano_filename, reflex_filename)
    draw_tympanogram
    output(tympano_filename)
#    draw_reflexgram
#    output(reflex_filename)
  end

end
