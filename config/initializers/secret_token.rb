# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Spark::Application.config.secret_key_base = '2a818b3422544b4b84860536950e8d990dd0f01bb1ab2c33986027a0046c75f04f49207abc64f50fda16758b7a1aa21f200d646039b8da4e748c6c1adbf3ebfe'
