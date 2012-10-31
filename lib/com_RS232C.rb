# com_RS232C.rb
# get data from an audiometer or an impedance audiometer via RS-232C (at most 2 port) 

require 'timeout'
require 'serialport'
require 'thread'

class Rs232c
  def initialize
    @q = Queue.new
    @port0 = "/dev/cuaU0"
    @port1 = "/dev/cuaU1"
    @baud_rate = 9600
    @data_bits = 7
    @stop_bits = 1
    @parity = SerialPort::EVEN
    @timelimit = 1200   # 外部からのrequestに対するtimelimit / 1200 seconds = 20 mins
    @timelimit_for_receiving = 5  # portから複数のデータを受ける際のtimelimit 4秒では取りこぼすことあり
  end

  def thread_reading_serialport(sp)
    stream = String.new
    return Thread.new do
      while ( c = sp.read(1) ) do    # RS-232C in
        stream << c
        if c.getbyte(0) == 0x3       # "R".getbyte(0) #=> 82 で文字コード取得(ruby19)
          @q.push(stream)
          break
        end
      end
      loop do end                    # thread 終了待ち
    end
  end

  def find_flag_raiser  # 先に手をあげた方のportのデータを取り、他方を捨てる
    port0_exist = File.exist?(@port0)
    port1_exist = File.exist?(@port1)
    if not (port0_exist || port1_exist)
      return "NoPort"
    end

    if port0_exist
      sp0 = SerialPort.new(@port0, @baud_rate, @data_bits, @stop_bits, @parity)
      t0 = thread_reading_serialport(sp0)
    end

    if port1_exist
      sp1 = SerialPort.new(@port1, @baud_rate, @data_bits, @stop_bits, @parity)
      t1 = thread_reading_serialport(sp1)
    end

    loop do
      if not @q.empty?
        t0.kill if t0
        t1.kill if t1
        break
      end
    end

    t0.join if t0
    t1.join if t1
    return @q.pop
  end

  def get_data_from_audiometer
    result = Array.new
    begin                                    # 最初のデータは長めに待つ
      timeout(@timelimit) do                 # timeout処理
        r = find_flag_raiser
        return ["NoPort"] if r == "NoPort"   # "NoPort"ならすぐに終了、["NoPort"]を返す
        result << r
      end
    rescue Timeout::Error
      return ["Timeout"]                     # 時間切れなら["Timeout"]を返す
    end

    loop do                                  # 後続のデータは少し待って, 来なければ終了する
      begin
        timeout(@timelimit_for_receiving) do
          result << find_flag_raiser
	end
      rescue Timeout::Error
        return result                        # 時間切れなら結果を返す
        break
      end
    end
  end
end

# ====================

if ($0 == __FILE__)
  d = Rs232c.new.get_data_from_audiometer
  puts n = d.length
  p d[n-1]
#  File.open("./data.dat","w") do |f|
#    d.each do |dd|
#      f.puts(dd)
#      f.puts("---")
#    end
#  end
end

