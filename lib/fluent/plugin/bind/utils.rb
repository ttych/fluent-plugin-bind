# frozen_string_literal: true

module Fluent
  module Plugin
    module Bind
      # Utilities related to bind/named
      module Utils
        FLAGS_REGEXP = /
        ^
        (?<recursion>(\+|-))
        ((?<signed>S))?
        ((?<edns>E\((?<edns_version>\d+)\)))?
        ((?<tcp>T))?
        ((?<dnssec>D))?
        ((?<checking_disabled>C))?
        ((?<valid_server_cookie>(V|K)))?
        /x.freeze

        def self.parse_flags(flags, prefix: '')
          m = FLAGS_REGEXP.match(flags)

          return {} unless m

          parsed_flags = {}
          m.names.each do |name|
            parsed_flags[prefix + name] = !m[name].nil?
          end

          parsed_flags["#{prefix}recursion"] = m['recursion'] == '+'
          parsed_flags["#{prefix}edns_version"] = m['edns_version'] ? m['edns_version'].to_i : nil
          parsed_flags["#{prefix}valid_server_cookie"] = case m['valid_server_cookie']
                                                         when 'V' then true
                                                         when 'K' then false
                                                         end
          parsed_flags
        end
      end
    end
  end
end

# Parsing rules, from documentation :
# Next, it reports whether the Recursion Desired flag was set (+ if set, - if not set),
# if the query was signed (S),
# EDNS was in used along with the EDNS version number (E(#)),
# if TCP was used (T),
# if DO(DNSSEC Ok) was set (D),
# if CD (Checking Disabled) was set (C),
# if a valid DNS Server COOKIE was received (V),
# or if a DNS COOKIE option without a valid Server COOKIE was present (K).
