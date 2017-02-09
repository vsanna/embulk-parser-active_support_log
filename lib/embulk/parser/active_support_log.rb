require_relative './active_support_parser'

module Embulk
  module Parser
    class ActiveSupportLog < ParserPlugin
      # config.ymlのtypeで指定する文字列
      Plugin.register_parser("active_support_log", self)

      LOG_FORMATS = %w(simple detail)

      def self.transaction(config, &control)
        # config.ymlのparser欄にて設定した値を取得
        log_format = config.param('log_format', :string).downcase
        parser_task = config.load_config(Java::LineDecoder::DecoderTask)

        # @taskというインスタンス変数に値を預けておいて、initialie時に前処理をしたいときに呼び出せるっぽい
        # taskなのかそれは
        task = {
          'log_format' => log_format,
          'decoder_task' => DataSource.from_java(parser_task.dump)
        }

        raise "you cannot select #{log_format}. choose from %(simple detail)" unless LOG_FORMATS.include?(log_format)

        # 出力カラムの設定
        columns = [
          Column.new(0, "pid", :long),
          Column.new(1, "message", :string),
          Column.new(2, "start_at", :timestamp),
          Column.new(3, "end_at", :timestamp),
        ]
        # :boolean, :long, :double, :string, :timestamp のみ

        # log_formatによって追加したりできるようにする
        # if log_format == 'detail'
        #   columns += [
        #     Column.new(4, 'severity', :string)
        #   ]
        # end

        # 実行スレッド数? 今も指定できる？
        # threads = 1

        yield(task, columns)
      end

      # 前処理
      def init
        # initialization code:
        @log_format = @task['log_format']
        @decoder_task = task.param("decoder_task", :hash).load_task(Java::LineDecoder::DecoderTask)
      end

      def run(file_input)
        decoder = Java::LineDecoder.new(file_input.instance_eval { @java_file_input }, @decoder_task)
        @parser = ActiveSupportParser.new(@log_format, decoder)

        while file = file_input.next_file
          @parser.parse(file, page_builder)
        end
        page_builder.finish
      end
    end
  end
end
