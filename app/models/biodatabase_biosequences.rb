class BiodatabaseBiosequences < ActiveRecord::Base
  belongs_to :biosequences
  belongs_to :biodatabases
end
