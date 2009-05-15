# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_coconutisland_session',
  :secret      => 'f0e04e8aad5f1681430d2be04f2c53f8866b979d962670117f8fad0dbc0dc31a7dbd5ad7322643eb52bf01c7ad3bb254bf2b907ef80dddcf4c576f251309013b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
