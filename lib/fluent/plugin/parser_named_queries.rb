# frozen_string_literal: true

#
# Copyright 2021- Thomas Tych
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fluent/plugin/parser'
require 'fluent/plugin/bind/utils'

module Fluent
  module Plugin
    # fluentd parser for bind/named queries format
    class NamedQueriesParser < Parser
      Fluent::Plugin.register_parser('named_queries', self)

      config_set_default :time_key, 'time'

      REGEXP = /
      ^
      ((?<time>\d{2}-\w{3}-\d{4}\s\d{2}:\d{2}:\d{2}.\d{3})\s)?
      ((?<category>queries):\s)?
      ((?<severity>(critical|error|warning|notice|info|debug)):\s)?
      client\s@(?<client_id>\w+)\s(?<client_ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}|(?:::)?(?:[a-zA-Z\d]{1,4}::?){1,7}[a-zA-Z\d]{0,4})\#(?<client_port>\d+)(\s\((?<client_query_name>[a-zA-Z\d.-]+)\))?:
      \sview\s(?<view>\w+):
      \s(?<message_type>query):
      \s(?<query_name>\S+)\s(?<query_class>\w+)\s(?<query_type>\w+)\s(?<query_flags>(?:\+|-)\S*)
      \s\((?<server_ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}|(?:::)?(?:[a-zA-Z\d]{1,4}::?){1,7}[a-zA-Z\d]{0,4})\)
      $
      /x.freeze

      TIME_FORMAT = '%d-%B-%Y %H:%M:%S.%L'

      def initialize(event_time = Fluent::EventTime)
        super()
        @mutex = Mutex.new
        @event_time = event_time
      end

      def configure(conf)
        super
        @time_parser = time_parser_create(format: TIME_FORMAT)
      end

      def parse(text)
        m = REGEXP.match(text)
        unless m
          yield nil, nil
          return
        end

        time = m['time']
        time = if time
                 @mutex.synchronize { @time_parser.parse(time) }
               else
                 @event_time.now
               end

        record = {}
        m.names.each do |name|
          next if name == 'time'

          record[name] = m[name] if m[name]
        end

        record['client_port'] = record['client_port'].to_i if record['client_port']

        record.update(Fluent::Plugin::Bind::Utils.parse_flags(record['query_flags'], prefix: 'query_flag_'))

        yield time, record
      end
    end
  end
end
