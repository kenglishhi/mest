class Jobs::Sync < Jobs::AbstractJob

  attr_reader :config
  attr_accessor :delayed_job

  def initialize
    @config = YAML.load_file(RAILS_ROOT+'/config/downloads.yml')[Rails.env][self.class.to_s.demodulize.gsub('Sync','').underscore]
  end

  def do_perform
    sync_from = calculate_sync_from
    #sync_from = '2002-01-01 00:00:00.000'
    pending_sync_count = calculate_pending_sync_count(sync_from)
    return unless pending_sync_count and pending_sync_count.to_i > 0
    pending_sync_count = pending_sync_count.to_i

    puts "Detected #{pending_sync_count} pending updates since #{sync_from}"
    offset = 0
    limit = 25

    DownloadResult.transaction do
      while (offset < pending_sync_count)
        puts "Downloading #{offset} through #{offset+limit-1} out of #{pending_sync_count}"
        response = execute_remote_query(sync_query(sync_from), offset, limit)

        download_result = DownloadResult.create!(:job_name => self.class.to_s,
                             :processed_xml => response.processed_xml,
                             :response_body => response.body)

        offset += limit
      end
    end
  end
  
  protected
  
  def execute_remote_query(query, offset = -1, limit = -1)
    QueryService.run_query(config['endpoint'],
                            config['username'],
                            config['password'],
                            persistence_unit,
                            query,
                            offset,
                            limit)
  end
  
  def persistence_unit
    raise "subclasses must implement"
  end
  
  # the query to pull actual records
  def sync_query(sync_by)
    raise "subclasses must implement"
  end
  
  # query remote service for count of new or updated objects
  def calculate_pending_sync_count(sync_from)
    response = execute_remote_query(pending_sync_count_query(sync_from))
    QueryService.extract_xml(response.processed_xml, '<long>', '</long>')
  end
  
  # the query to count how many records we are about to sync
  def pending_sync_count_query(sync_from)
    raise "subclasses must implement"
  end
  
  # check locally for what we are syncing by
  def calculate_sync_from
    sync_from_class.connection.select_value(sync_from_query)
  end
  
  # what is max of local sync from?
  def sync_from_query
    raise "subclasses must implement"
  end
  
  # what class has the connection we will use for local sync from
  def sync_from_class
    raise "subclasses must implement"
  end

end