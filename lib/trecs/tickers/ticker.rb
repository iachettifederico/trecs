module TRecs
  class Ticker
    attr_accessor :player

    def start
      prev_time = 0
      player.timestamps.each do |time|
        player.tick(time)
        sleep((time - prev_time)/1000.0)
        prev_time = time
      end
      true
    end
  end
end
