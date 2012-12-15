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
    @r_y_ofs = [42, 82, 134, 174, 226, 266, 318, 358]   # reflex y-axis offset

    if File.exist?(Image_parts_location+"background_tympanogram.png")
      @png_t = ChunkyPNG::Image.from_file(Image_parts_location +
                                         "background_tympanogram.png")
    else
      @png_t = ChunkyPNG::Image.new(400,400,WHITE)
      make_tympano_background
      @png_t.save(Image_parts_location+"background_tympanogram.png", :fast_rgba)
    end

    if File.exist?(Image_parts_location+"background_reflex.png")
      @png_r = ChunkyPNG::Image.from_file(Image_parts_location+"background_reflex.png")
    else
      @png_r = ChunkyPNG::Image.new(400,400,WHITE)
      make_reflex_background
      @png_r.save(Image_parts_location+"background_reflex.png", :fast_rgba)
    end

    @tympanodata = impedancedata.extract[:tympano]
    @reflexdata = impedancedata.extract[:reflex]
  end

  def make_tympano_background
    [0, 200].each do |offset|
      x1 = 70; x2 = 369; x01 = 169; x02 = 269 
      y1 = 30+offset; y2 = 169+offset; y0 = 149+offset
      line(@png_t, x1, y1, x1, y2, GRAY, "line")
      line(@png_t, x2, y1, x2, y2, GRAY, "line")
      line(@png_t, x1, y1, x2, y1, GRAY, "line")
      line(@png_t, x1, y2, x2, y2, GRAY, "line")
      line(@png_t, x01, y1, x01, y2, GRAY, "dot")
      line(@png_t, x02, y1, x02, y2, GRAY, "line")
      line(@png_t, x1, y0, x2, y0, GRAY, "line")
      
      put_font(@png_t, 20, 100+offset-8, ["R", "L"][offset == 0? 0: 1])
      put_font(@png_t, 49, y1-15-8, "mL")
      put_font(@png_t, x2-25, y2+15, "daPa")

      l = [["0", 58, y0-8], ["0.5", 42, y0-40-8], ["1.0", 42, y0-80-8], ["1.5", 42, y1-8],
           ["-400", x1-16, y2], ["-200", x01-16, y2], ["0", x02-4, y2], ["200", x2-12 ,y2]]
      l.each do |ll|
        put_string(@png_t, ll[1], ll[2], ll[0])
      end
    end
  end

  def make_reflex_background
    @r_y_ofs.each do |o|         # @r_y_ofs = [42, 82, 134, 174, 226, 266, 318, 358] # reflex y-axis offset
      line(@png_r, 110, o, 365, o, GRAY, "line")
    end
    line(@png_r, 110, 20, 110, 379, GRAY, "line")
    line(@png_r, 365, 20, 365, 379, GRAY, "line")
    put_string(@png_r, 15,  57, "R 500Hz")
    put_string(@png_r, 15, 149, "R 1kHz")
    put_string(@png_r, 15, 241, "L 500Hz")
    put_string(@png_r, 15, 333, "L 1kHz")
    put_font(@png_r, 365, 6, "dB")
    4.times do |i|
      put_font(@png_r, 80, @r_y_ofs[i*2] - 7,   "ipsi")
      put_font(@png_r, 80, @r_y_ofs[i*2+1] - 7, "cntr")
    end
    4.times do |i|
      x = 15 + 60 * i
      s = (80 + 10 * i).to_s
      line(@png_r, 110+ x, 19, 140+x, 19, BLACK, "line")
      line(@png_r, 110+ x, 20, 140+x, 20, GRAY, "line")
      put_string(@png_r, 110+x, 6, s)
      line(@png_r, 110+ x, 199, 140+x, 199, BLACK, "line")
      line(@png_r, 110+ x, 200, 140+x, 200, GRAY, "line")
      line(@png_r, 110+ x, 20, 110+ x, 379, GRAY, "dot")
      line(@png_r, 140+ x, 20, 140+ x, 379, GRAY, "dot")
    end
  end

  def put_string(png, x, y, str)
    hz_flag = false
    str.each_byte do |c|
      case c
      when 32   # " "
        # do nothing
      when 45                  # if character is "-"
        put_font(png, x, y, "minus")
      when 46                  # if character is "."
        put_font(png, x, y, "dot")
      when 72   # "H"
        hz_flag = true
	x -= 8
      when 122  # "z"
        put_font(png, x, y, "Hz") if hz_flag
	hz_flag = false
      else
        put_font(png, x, y, "%c" % c)
      end
      x += 8
    end
  end

  def draw_reflexgram
    y_offset = {"R500Hzipsi" => @r_y_ofs[0], "R500Hzcntr" => @r_y_ofs[1], "R1kHzipsi" => @r_y_ofs[2], "R1kHzcntr" => @r_y_ofs[3],\
                "L500Hzipsi" => @r_y_ofs[4], "L500Hzcntr" => @r_y_ofs[5], "L1kHzipsi" => @r_y_ofs[6], "L1kHzcntr" => @r_y_ofs[7]}
    color_list = {"R500Hzipsi" => RED,  "R500Hzcntr" => RED_PRE1,  "R1kHzipsi" => RED,  "R1kHzcntr" => RED_PRE1,\
                  "L500Hzipsi" => BLUE, "L500Hzcntr" => BLUE_PRE1, "L1kHzipsi" => BLUE, "L1kHzcntr" => BLUE_PRE1}
    @reflexdata.each do |r|
      pvt = r[:pvt]          # その他のパラメータ "#{r[:side]} / #{r[:freq]} / #{r[:stim_side]} / #{r[:interval]}"
      condition = r[:side] + r[:freq] + r[:stim_side]

#      r[:values].each do |v| # 刺激音の状態の調査用
#        s = String.new
#        puts "#{v[0]}/#{condition}: #{ v[1].each {|value| s << (value[:stim_on]? "o": "x")}; s } : #{s.size}"
#      end

      x0, y0 = 110, y_offset[condition]
      x1, y1 = x0, y0
      x = x1
      color = color_list[condition]
      r[:values].each do |v|
        v[1].each do |value|
          v = value[:vol] - pvt  # その他のパラメータ value[:stim_on]
          y = y0 - (v * 150).to_i
#          line(@png_r, x1, y1, x.to_i, y, (value[:stim_on]? color: BLACK), "line")  # alternate appearance: not work well for now
          line(@png_r, x1, y1, x.to_i, y, color, "line")
          x1 = x.to_i
          y1 = y
          x += 1
        end
      end
    end
  line(@png_r, 368, 379 - 0.1 * 150, 368, 379, GRAY, "line") 
  line(@png_r, 369, 379 - 0.1 * 150, 369, 379, BLACK, "line") 
  put_string(@png_r, 372, 367, "0.1")
  put_font(@png_r, 377, 379, "mL")
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
    line(@png_t, x1.to_i, y1.to_i, x2.to_i, y2.to_i, color, line)
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

  def reflex_misc_data
    result = {"R" => {}, "L" => {}}
    @reflexdata.each do |r|
      side = (r[:side] == "R")? "R": "L"
      result[side] = {:pvt => r[:pvt], :pressure => r[:pressure]}
    end
    return result
  end

  def reflex_pvt
    return {:rt => reflex_misc_data["R"][:pvt], :lt => reflex_misc_data["L"][:pvt]}
  end

  def reflex_pressure
    return {:rt => reflex_misc_data["R"][:pressure], :lt => reflex_misc_data["L"][:pressure]}
#    @reflexdata.each do |r|
#:side => side, :freq => freq, :stim_side => stim_side,\ :pvt => pvt, :pressure => pressure, :interval => interval,\
#      p r[:pressure]
#p r[:pvt]
#    end
  end

  def dump_png
    dumps = Array.new
    draw_tympanogram
    dumps = {:tympanogram => dump(@png_t), :reflex => dump(@png_r)}
    draw_reflexgram
    return dumps
  end

  def draw(tympano_filename, reflex_filename)
    draw_tympanogram
    output(@png_t, tympano_filename)
    draw_reflexgram
    output(@png_r, reflex_filename)
  end

end
