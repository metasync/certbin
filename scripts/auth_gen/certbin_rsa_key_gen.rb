# frozen_string_literal: true

require 'openssl'

issuer = ARGV[0]

abort 'Error: issuer is missing!' if issuer.nil?

rsa_key = OpenSSL::PKey::RSA.generate 4096

base_path = File.expand_path('../../authorized_keys', File.dirname(__FILE__))
private_key_file = File.join(base_path, "#{issuer}.priv")
public_key_file = File.join(base_path, "#{issuer}.pub")

print "Saving private Key (#{private_key_file}) ... "
File.write(private_key_file, rsa_key.to_pem)
puts 'done'

print "Saving public key (#{public_key_file}) ..."
File.write(public_key_file, rsa_key.public_to_pem)
puts 'done'

puts 'Private key:'
cert = OpenSSL::PKey::RSA.new File.binread(private_key_file)
puts cert.to_pem

puts 'Public key:'
cert = OpenSSL::PKey::RSA.new File.binread(public_key_file)
puts cert.public_to_pem
