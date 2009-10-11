module Tools::BiosequenceRenamersHelper

  def biodatabase_options
    Biodatabase.find(:all, :order => 'name' ).map { |ff| [ff.name, ff.id ] }
  end

end
