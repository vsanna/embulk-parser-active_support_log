module Embulk
  module Parser
    class ActiveSupportParser
      attr_accessor :log_format
      attr_accessor :decoder
      attr_accessor :current_data_record

      # データを取り扱う箱
      DataRecord = Struct.new(:pid, :message, :start_at, :end_at)
      DataItem = Struct.new(:severity_id, :timestamp, :pid, :severity, :message)

      def initialize(log_format_type, decoder)
        @log_format = select_format(log_format_type)
        @decoder = decoder
        @current_data_record = nil
      end

      def parse(page_builder)
        while decoder.nextFile
          while line = decoder.poll
            line = line.gsub(/\e/, '')
            data = line_to_item(line)
            next if data.nil?
            next if current_data_record.nil? && set_current_data_record(data)
            # pidがかわった = 別の処理に行動ログに移った
            if current_data_record.pid != data.pid
              page_builder.add(current_data_record.values)
              set_current_data_record(data)
            else
              current_data_record.message = current_data_record.message + "<br />" + data.message
              current_data_record.end_at = data.timestamp
            end
          end
        end
      end

      private

      def select_format(format_type)
        # 実際にはこういう分岐をconfig.ymlから受け取った変数で行ったりする
        case format_type
        when 'simple'
          /\A([A-Z])*, \[([0-9T:.-]*) #([0-9]*)\] ([A-Z\s]*) -- : (.*)/
          # when 'detail'
          #   /\A([A-Z])*, \[([0-9T:.-]*) #([0-9]*)\] ([A-Z\s]*) -- : (.*)/)
        end
      end

      def line_to_item(line)
        parsed = line.match(log_format)
        return nil if parsed.nil?

        severity_id = parsed[1].strip # 重症度という意味らしい
        timestamp = Time.new(parsed[2]).to_i # こうしないと渡らない
        pid = parsed[3].strip
        severity = parsed[4].gsub(/\s/, '')
        message = parsed[5].strip

        DataItem.new(*[severity_id, timestamp, pid, severity, message])
      end

      def set_current_data_record(data)
        @current_data_record = DataRecord.new(data.pid,
                                             data.message,
                                             data.timestamp,
                                             data.timestamp)
      end
    end


  end
end

