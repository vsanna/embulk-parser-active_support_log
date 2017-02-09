require 'pry'

class ActiveSupportParser
  attr_accessor :log_format
  attr_accessor :decoder
  attr_accessor :current_data_record

  # データを取り扱う箱
  DataRecord = Struct.new(:pid, :message, :start_at, :end_at)
  DataItem = Struct.new(:severity_id, :timestamp, :pid, :severity, :message)

  def initialize(log_format_type, decoder)
    binding.pry
    log_format = select_format(log_format_type)
    self.decoder = decoder
    current_data_record = nil
  end

  def parse(file, page_builder)
    while decoder.nextFile
      while line = decoder.poll
        data = line_to_item(line)
        next if data.nil?
        next if current_data_record.nil? && set_current_data_record(data)

        # pidがかわった = 別の処理に行動ログに移った
        if current_data_record.pid != data.pid
          page_builder.add(current_data_record.values)
          set_current_data_record(data)
        else
          current_data_record.message = current_data_record.message + "\r\n" + data.message
          current_data_record.end_at = data.timestamp
        end
      end
    end

    # file.each_line do |line|
    #   data = line_to_item(line)
    #   next if data.nil?
    #   next if current_data_record.nil? && set_current_data_record(data)
    #
    #   # pidがかわった = 別の処理に行動ログに移った
    #   if current_data_record.pid != data.pid
    #     page_builder.add(current_data_record.values)
    #     set_current_data_record(data)
    #   else
    #     current_data_record.message = current_data_record.message + "\r\n" + data.message
    #     current_data_record.end_at = data.timestamp
    #   end
    # end
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

    severity_id = parsed[1] # 重症度という意味らしい
    timestamp = parsed[2]
    pid = parsed[3]
    severity = parsed[4].gsub(/\s/, '')
    message = parsed[5]

    DataItem.new(*[severity_id, timestamp, pid, severity, message].map { |e| e.gsub(/,/, '') })
  end

  def set_current_data_record(data)
    current_data_record = DataRecord.new(data.pid,
                                         data.message,
                                         data.timestamp,
                                         data.timestamp)
  end
end

