# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
secret_file = File.join(RAILS_ROOT,"config","secret")
if File.exist?(secret_file)
  secret=File.read(secret_file)
else
  secret = '0f3572bce9605510e829c2950e52d1da78512631f29f9db8a96d4e846966214388e32dfe064537ac99421dee48859dff74e9ecfe091083f3c07e34dd6842a479'
end

Sims::Application.config.secret_token = secret
