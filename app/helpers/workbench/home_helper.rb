module Workbench::HomeHelper
  def biosequence_page_size
    Biosequence.per_page 
  end
  def biodatabase_group_page_size
    BiodatabaseGroup.per_page
  end
  def biodatabase_page_size
    Biodatabase.per_page
  end
  def blast_result_page_size
    BlastResult.per_page
  end
end
