# frozen_string_literal: true

require 'helper'
require 'fluent/plugin/bind/utils'

# Test for Utils#parse_flags
class UtilsParseFlagsTest < Test::Unit::TestCase
  sub_test_case 'on flag parsing' do
    test 'parse recursion enabled flag' do
      flags = '+'
      expected_parsed_flags = {
        'recursion' => true,
        'signed' => false,
        'edns' => false,
        'edns_version' => nil,
        'tcp' => false,
        'dnssec' => false,
        'checking_disabled' => false,
        'valid_server_cookie' => nil
      }
      parsed_flags = Fluent::Plugin::Bind::Utils.parse_flags(flags)

      assert_equal(expected_parsed_flags, parsed_flags)
    end

    test 'parse recursion disabled flag' do
      flags = '-'
      expected_parsed_flags = {
        'recursion' => false,
        'signed' => false,
        'edns' => false,
        'edns_version' => nil,
        'tcp' => false,
        'dnssec' => false,
        'checking_disabled' => false,
        'valid_server_cookie' => nil
      }
      parsed_flags = Fluent::Plugin::Bind::Utils.parse_flags(flags)

      assert_equal(expected_parsed_flags, parsed_flags)
    end

    test 'parse signed flag' do
      flags = '+S'
      expected_parsed_flags = {
        'recursion' => true,
        'signed' => true,
        'edns' => false,
        'edns_version' => nil,
        'tcp' => false,
        'dnssec' => false,
        'checking_disabled' => false,
        'valid_server_cookie' => nil
      }
      parsed_flags = Fluent::Plugin::Bind::Utils.parse_flags(flags)

      assert_equal(expected_parsed_flags, parsed_flags)
    end

    test 'parse edns flag' do
      flags = '+E(0)'
      expected_parsed_flags = {
        'recursion' => true,
        'signed' => false,
        'edns' => true,
        'edns_version' => 0,
        'tcp' => false,
        'dnssec' => false,
        'checking_disabled' => false,
        'valid_server_cookie' => nil
      }
      parsed_flags = Fluent::Plugin::Bind::Utils.parse_flags(flags)

      assert_equal(expected_parsed_flags, parsed_flags)
    end

    test 'parse tcp flag' do
      flags = '+T'
      expected_parsed_flags = {
        'recursion' => true,
        'signed' => false,
        'edns' => false,
        'edns_version' => nil,
        'tcp' => true,
        'dnssec' => false,
        'checking_disabled' => false,
        'valid_server_cookie' => nil
      }
      parsed_flags = Fluent::Plugin::Bind::Utils.parse_flags(flags)

      assert_equal(expected_parsed_flags, parsed_flags)
    end

    test 'parse dnssec flag' do
      flags = '+D'
      expected_parsed_flags = {
        'recursion' => true,
        'signed' => false,
        'edns' => false,
        'edns_version' => nil,
        'tcp' => false,
        'dnssec' => true,
        'checking_disabled' => false,
        'valid_server_cookie' => nil
      }
      parsed_flags = Fluent::Plugin::Bind::Utils.parse_flags(flags)

      assert_equal(expected_parsed_flags, parsed_flags)
    end

    test 'parse checking_disabled flag' do
      flags = '+C'
      expected_parsed_flags = {
        'recursion' => true,
        'signed' => false,
        'edns' => false,
        'edns_version' => nil,
        'tcp' => false,
        'dnssec' => false,
        'checking_disabled' => true,
        'valid_server_cookie' => nil
      }
      parsed_flags = Fluent::Plugin::Bind::Utils.parse_flags(flags)

      assert_equal(expected_parsed_flags, parsed_flags)
    end

    test 'parse valid_server_cookie flag' do
      flags = '+V'
      expected_parsed_flags = {
        'recursion' => true,
        'signed' => false,
        'edns' => false,
        'edns_version' => nil,
        'tcp' => false,
        'dnssec' => false,
        'checking_disabled' => false,
        'valid_server_cookie' => true
      }
      parsed_flags = Fluent::Plugin::Bind::Utils.parse_flags(flags)

      assert_equal(expected_parsed_flags, parsed_flags)
    end

    test 'parse invalid_server_cookie flag' do
      flags = '+K'
      expected_parsed_flags = {
        'recursion' => true,
        'signed' => false,
        'edns' => false,
        'edns_version' => nil,
        'tcp' => false,
        'dnssec' => false,
        'checking_disabled' => false,
        'valid_server_cookie' => false
      }
      parsed_flags = Fluent::Plugin::Bind::Utils.parse_flags(flags)

      assert_equal(expected_parsed_flags, parsed_flags)
    end

    test 'return empty hash field when parsing failed' do
      flags = ''
      expected_parsed_flags = {}
      parsed_flags = Fluent::Plugin::Bind::Utils.parse_flags(flags)

      assert_equal(expected_parsed_flags, parsed_flags)
    end
  end

  sub_test_case 'with prefix' do
    test 'add prefix to parsed flag key name' do
      flags = '+'
      expected_parsed_flags = {
        'query_flag_recursion' => true,
        'query_flag_signed' => false,
        'query_flag_edns' => false,
        'query_flag_edns_version' => nil,
        'query_flag_tcp' => false,
        'query_flag_dnssec' => false,
        'query_flag_checking_disabled' => false,
        'query_flag_valid_server_cookie' => nil
      }
      parsed_flags = Fluent::Plugin::Bind::Utils.parse_flags(flags, prefix: 'query_flag_')

      assert_equal(expected_parsed_flags, parsed_flags)
    end
  end
end
