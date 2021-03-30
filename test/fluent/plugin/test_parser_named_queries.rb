# frozen_string_literal: true

require 'helper'
require 'fluent/plugin/parser_named_queries'

module FakeEventTime
  def self.now
    'fake_time'
  end
end

class NamedQueriesParserTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  sub_test_case 'parse' do
    test 'parse simple log entry' do
      d = create_driver
      text = 'client @0x7f2534000cd0 127.0.0.1#33923 (www.google.com): '\
        'view in: '\
        'query: www.google.com IN A +E(0)K '\
        '(127.0.0.1)'
      expected_time = 'fake_time'
      expected_record = {
        'client_id' => '0x7f2534000cd0',
        'client_ip' => '127.0.0.1',
        'client_port' => 33_923,
        'client_query_name' => 'www.google.com',
        'view' => 'in',
        'message_type' => 'query',
        'query_name' => 'www.google.com',
        'query_class' => 'IN',
        'query_type' => 'A',
        'query_flags' => '+E(0)K',
        'query_flag_checking_disabled' => false,
        'query_flag_dnssec' => false,
        'query_flag_edns' => true,
        'query_flag_edns_version' => 0,
        'query_flag_recursion' => true,
        'query_flag_signed' => false,
        'query_flag_tcp' => false,
        'query_flag_valid_server_cookie' => false,
        'server_ip' => '127.0.0.1'
      }
      d.instance.parse(text) do |time, record|
        assert_equal(expected_time, time)
        assert_equal(expected_record, record)
      end
    end

    test 'parse log entry with time' do
      d = create_driver
      text = '28-Mar-2021 13:04:29.494 '\
        'client @0x7f37dc000cd0 127.0.0.1#38974 (www.yahoo.com): '\
        'view out: '\
        'query: www.yahoo.com IN A +E(0)K '\
        '(127.0.0.1)'
      expected_time = event_time('28-Mar-2021 13:04:29.494', format: '%d-%B-%Y %H:%M:%S.%L')
      expected_record = {
        'client_id' => '0x7f37dc000cd0',
        'client_ip' => '127.0.0.1',
        'client_port' => 38_974,
        'client_query_name' => 'www.yahoo.com',
        'view' => 'out',
        'message_type' => 'query',
        'query_name' => 'www.yahoo.com',
        'query_class' => 'IN',
        'query_type' => 'A',
        'query_flags' => '+E(0)K',
        'query_flag_checking_disabled' => false,
        'query_flag_dnssec' => false,
        'query_flag_edns' => true,
        'query_flag_edns_version' => 0,
        'query_flag_recursion' => true,
        'query_flag_signed' => false,
        'query_flag_tcp' => false,
        'query_flag_valid_server_cookie' => false,
        'server_ip' => '127.0.0.1'
      }
      d.instance.parse(text) do |time, record|
        assert_equal(expected_time, time)
        assert_equal(expected_record, record)
      end
    end

    test 'parse log entry with info severity' do
      d = create_driver
      text = 'info: '\
        'client @0x7f3460000cd0 127.0.0.1#33048 (github.com): '\
        'view in: '\
        'query: github.com IN A +E(0)K '\
      '(127.0.0.1)'
      expected_time = 'fake_time'
      expected_record = {
        'client_id' => '0x7f3460000cd0',
        'client_ip' => '127.0.0.1',
        'client_port' => 33_048,
        'client_query_name' => 'github.com',
        'view' => 'in',
        'message_type' => 'query',
        'query_name' => 'github.com',
        'query_class' => 'IN',
        'query_type' => 'A',
        'query_flags' => '+E(0)K',
        'query_flag_checking_disabled' => false,
        'query_flag_dnssec' => false,
        'query_flag_edns' => true,
        'query_flag_edns_version' => 0,
        'query_flag_recursion' => true,
        'query_flag_signed' => false,
        'query_flag_tcp' => false,
        'query_flag_valid_server_cookie' => false,
        'server_ip' => '127.0.0.1',
        'severity' => 'info'
      }
      d.instance.parse(text) do |time, record|
        assert_equal(expected_time, time)
        assert_equal(expected_record, record)
      end
    end

    test 'parse log entry with category' do
      d = create_driver
      text = 'queries: '\
        'client @0x7f9da8000cd0 127.0.0.1#36027 (gitlab.com): '\
        'view in: '\
        'query: gitlab.com IN A +E(0)K '\
      '(127.0.0.1)'
      expected_time = 'fake_time'
      expected_record = {
        'client_id' => '0x7f9da8000cd0',
        'client_ip' => '127.0.0.1',
        'client_port' => 36_027,
        'client_query_name' => 'gitlab.com',
        'view' => 'in',
        'message_type' => 'query',
        'query_name' => 'gitlab.com',
        'query_class' => 'IN',
        'query_type' => 'A',
        'query_flags' => '+E(0)K',
        'query_flag_checking_disabled' => false,
        'query_flag_dnssec' => false,
        'query_flag_edns' => true,
        'query_flag_edns_version' => 0,
        'query_flag_recursion' => true,
        'query_flag_signed' => false,
        'query_flag_tcp' => false,
        'query_flag_valid_server_cookie' => false,
        'server_ip' => '127.0.0.1',
        'category' => 'queries'
      }
      d.instance.parse(text) do |time, record|
        assert_equal(expected_time, time)
        assert_equal(expected_record, record)
      end
    end

    test 'parse full log entry' do
      d = create_driver
      text = '28-Mar-2021 09:58:22.345 '\
        'queries: '\
        'info: '\
        'client @0x7f9908000cd0 127.0.0.1#46947 (google.com): '\
        'view in: '\
        'query: google.com IN NS +E(0)K '\
      '(127.0.0.1)'
      expected_time = event_time('28-Mar-2021 09:58:22.345', format: '%d-%B-%Y %H:%M:%S.%L')
      expected_record = {
        'client_id' => '0x7f9908000cd0',
        'client_ip' => '127.0.0.1',
        'client_port' => 46_947,
        'client_query_name' => 'google.com',
        'view' => 'in',
        'message_type' => 'query',
        'query_name' => 'google.com',
        'query_class' => 'IN',
        'query_type' => 'NS',
        'query_flags' => '+E(0)K',
        'query_flag_checking_disabled' => false,
        'query_flag_dnssec' => false,
        'query_flag_edns' => true,
        'query_flag_edns_version' => 0,
        'query_flag_recursion' => true,
        'query_flag_signed' => false,
        'query_flag_tcp' => false,
        'query_flag_valid_server_cookie' => false,
        'server_ip' => '127.0.0.1',
        'category' => 'queries',
        'severity' => 'info'

      }
      d.instance.parse(text) do |time, record|
        assert_equal(expected_time, time)
        assert_equal(expected_record, record)
      end
    end
  end

  private

  def create_driver(conf = {})
    Fluent::Test::Driver::Parser.new(Fluent::Plugin::NamedQueriesParser.new(FakeEventTime)).configure(conf)
  end
end
