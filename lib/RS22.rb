#!/usr/local/bin/ruby
# coding: UTF-8
#  Class ImpedanceData: インピーダンスオージオグラム"生データ"取扱い用クラス
#  Copyright 2012 S Mamiya <MamiyaShn@gmail.com>

class ImpedanceData
  def initialize(data_array) # ここに入るのはRS-232Cから得た生データ、データは配列に入る
    @made_from_rawdata = true
    if not data_array[0][0..1] == "5"               # Impedance audiometerの確認
      raise "format error"
    end
    @results = {:tympano => [], :reflex => []} 
    data_array.each do |d|
      case d[2]
      when 'J'         # when "tympanometry"
        set_tympanodata(d)
      when 'M', 'K'    # when "reflex"
        set_reflexdata(d)
      else
        # do nothing
      end
    end
  end

  def set_tympanodata(data)
    if /(.+)\/(.+)/ =~ clip_data(data)
      property_data = $1   
      value_data =  $2
    end
    data_length = property_data[0..2].to_i
    interval = property_data[3..6].to_f * 0.01
    side = property_data[7]           # 'R' or 'L'
    value = value_data.split(/,/)
    pvt = conv_to_value(value[0])     # PVT:  +200daPa時の等価容積      [mL]
    sc = conv_to_value(value[1])      # SC:   Static Comliance 等価容積 [mL]
    peak = (value[2][0] == '+'? 1: -1) *\
           (value[2][1].to_i * 100 + value[2][2].to_i * 10 + value[2][3].to_i)
                                      # PEAK: 等価容積が最大の時の圧力  [daPa]
    value_arr = Array.new
    3.upto(data_length - 1) do |i|
      value_arr[i-3] =  conv_to_value(value[i])
    end
    @results[:tympano] << {:side => side, :pvt => pvt, :sc => sc, :peak => peak,\
                           :values => value_arr, :interval => interval}
  end
    
  def set_reflexdata(data)
    lookup_frequency = {"2" => "250Hz", "3" => "500Hz", "4" => "1kHz", "5" => "2kHz",\
                        "6" => "4kHz", "7" => "8kHz",\
                        "@" => "WideNoise", "A" => "LowNoise", "B" => "HighNoise"}
    if /(.+)\/(.+)/ =~ clip_data(data)
      property_data = $1   
      value_data =  $2
    end
    data_length = property_data[0..2].to_i
    interval = property_data[3..6].to_f * 0.01
    side = property_data[7]           # 'R' or 'L'
    pressure = (property_data[8] == '+'? 1: -1) * 
                property_data[9].to_i * 100 + property_data[10].to_i * 10 + property_data[11].to_i
                                      # 圧力  [daPa]
    value = value_data.split(/,/)
    pvt = conv_to_value(value[0])     # PVT:  +200daPa時の等価容積      [mL]
    freq = lookup_frequency[value[3][0]]
    stim_side = value[3][2].to_i < 2? "ipsi": "cntr"
    values = Hash.new
    3.upto(data_length - 1) do |i|
      lev = 50 + (value[i][1].getbyte(0) - 58) * 5
      lev -= 75 if lev > 120
      lev = lev.to_s
      values[lev] = Array.new if not values.has_key?(lev)
      stim_on = value[i][2].to_i % 2 == 0? true: false
      vol = conv_to_value(value[i][3..6])
      values[lev] << {:stim_on => stim_on, :vol => vol}
    end
    @results[:reflex] << {:side => side, :freq => freq, :stim_side => stim_side,\
                          :pvt => pvt, :pressure => pressure, :interval => interval,\
                          :values => values }
  end

  def extract
    return @results
  end

  def conv_to_value(str_arr)
    return str_arr.to_f * 0.001
  end

  def clip_data(data)
    i = 0
    bcc = 0
    separator_count = 0
    while data.getbyte(i) != 2     # <stx>までスキップする
      i += 1
    end
    i += 1
    return "machine_error" if data.getbyte(i) != 0x35 # 検査機器コードの確認
    bcc ^= data.getbyte(i)
    i += 1

    case data.getbyte(i)
    when 0x4a          # 'J': tympanometry
      mode = "tympanometry"
    when 0x4d, 0x4b    # 'M': reflex auto, 'K': reflex manual
      mode = "reflex"
    else
      return "exam_error"
    end
    bcc ^= data.getbyte(i)
    i += 1

    while c = data.getbyte(i)
      if c == 0x2f then     # 区切り文字があれば数をかぞえて
        separator_count += 1
        case separator_count
        when 3              # 3つめの次と
          data_begin = i + 1
        when 5              # 5つめの前をマーク
          data_end = i - 1
        end
      end
      bcc ^= c              # 傍らでひたすらXORを取り続ける
      i += 1
      break if separator_count == 5     # 5つめの区切り文字がでたら終了
    end
    if bcc != data.getbyte(i) then              # <bcc>とその手前までのデータのXORを比較
      puts "BCC error"
      return "communication_error"      # 異なれば通信エラー
    else
      return data[data_begin..data_end] # 等しければ属性情報と検査データのみを返す
    end
  end
end

#-----
if ($0 == __FILE__)
  require 'pp'

  datafiles_t = ["./tympanodata/data0.dat", "./tympanodata/data1.dat"]
  tympanograms = Array.new
  datafiles_t.each do |d|
    buf = String.new
    File.open(d,"r") do |f|
      buf = f.read
    end
    tympanograms << buf
  end
  d = ImpedanceData.new(tympanograms)
#  p  d.extract

  datafiles_r = Array.new
  0.upto(7) do |i|
    datafiles_r << "./reflexdata/data#{i}.dat"
  end
  reflexes = Array.new
  datafiles_r.each do |d|
    buf = String.new
    File.open(d,"r") do |f|
      buf = f.read
    end
    reflexes << buf
  end
  d = ImpedanceData.new(reflexes)
  p  d.extract
end
