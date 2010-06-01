# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_selector_test_session',
  :secret      => '04fecbebe7cba1f96df2ce70826c49a7fb26b1c9f506be1d831f71c0973a0b149aebca856a5282122deab1d62f475aabeac517307a96c868702ae6505b85793a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
