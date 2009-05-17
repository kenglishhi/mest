class BiodatabaseBiosequence < ActiveRecord::Base
  belongs_to :biosequence
  belongs_to :biodatabase
end
