class Jobs::AirForceSync < Jobs::Sync
  
  protected
  
  def next_job_name
    "Jobs::AirForceMergeToRaw"
  end
  
  def persistence_unit
    'afsas'
  end
  
  def sync_from_class
    Sources::AirForce::Afsas::DwMishap
  end
  
  def sync_from_query
    "SELECT MAX(mshp_last_message_date) FROM dw_mishap"
  end
  
  def sync_query(sync_from)
    "SELECT m FROM DwMishap m WHERE COALESCE(m.mshpLastMessageDate, m.mshpDate) >= TO_DATE('#{remove_milliseconds(sync_from)}', 'YYYY-MM-DD HH24:MI:SS') ORDER BY m.mshpId"
  end
  
  def pending_sync_count_query(sync_from)
    "SELECT COUNT(m) FROM DwMishap m WHERE COALESCE(m.mshpLastMessageDate, m.mshpDate) >= TO_DATE('#{remove_milliseconds(sync_from)}', 'YYYY-MM-DD HH24:MI:SS')"
  end
  
  private
  
  def remove_milliseconds(sync_from)
    sync_from.gsub(/\.[0-9]{3}$/, '')
  end
end
