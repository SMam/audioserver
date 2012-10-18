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
    @timelimit = 1200   # i.e. 1200 seconds = 20 mins
  end

  def thread_reading_serialport(sp)
    stream = String.new
    return Thread.new do
      begin
        timeout(@timelimit) do           # timeout処理
          while ( c = sp.read(1) ) do    # RS-232C in
            stream << c
            if c.getbyte(0) == 0x3       # "R".getbyte(0) #=> 82 で文字コード取得(ruby19)
              @q.push(stream)
              break
            end
          end
        end
      rescue Timeout::Error
        @q.push("Timeout")               # 時間切れなら"Timeout"を返す
      end
      loop do end                        # thread 終了待ち
    end
  end

  def get_data_from_audiometer
    if not (port0_exist = File.exist?(@port0) || port1_exist = File.exist?(@port1))
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
        t0.kill
	t1.kill
        break
      end
    end

    t0.join
    t1.join 
    return @q.pop
  end
end

if ($0 == __FILE__)
  d = Rs232c.new.get_data_from_audiometer
  puts d
#  File.open("./data.dat","w") do |f|
#    f.puts(d)
#  end
end

