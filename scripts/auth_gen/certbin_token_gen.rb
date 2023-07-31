# frozen_string_literal: true

require 'openssl'
require 'jwt'

issuer = ARGV[0]

abort 'Error: issuer is missing!' if issuer.nil?

base_path = File.expand_path('../../authorized_keys', File.dirname(__FILE__))
private_key_file = File.join(base_path, "#{issuer}.priv")
public_key_file = File.join(base_path, "#{issuer}.pub")

expires_in = 5 # min
payload = {
  iss: issuer,
  iat: Time.now.to_i,
  exp: Time.now.to_i + (expires_in * 60),
  data: {
    user: 'chiman.lei'
  }
}

algorithm = 'RS256'

private_key = OpenSSL::PKey::RSA.new File.binread(private_key_file)
auth_token = JWT.encode(
  payload,
  private_key,
  algorithm
)

puts "Auth token:"
puts auth_token.inspect

required_issuers = ['devops', 'syseng']
required_claims = ['iss', 'iat', 'exp']

decoded_token = JWT.decode(auth_token, nil, true,
  {
    iss: required_issuers,
    verify_iss: true,
    verify_iat: true,
    required_claims: required_claims,
    algorithm: algorithm
  }) do |_headers, _payload| 
    OpenSSL::PKey::RSA.new File.binread(public_key_file) 
  end

puts "Decoded payload:"
puts decoded_token.inspect