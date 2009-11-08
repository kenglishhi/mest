class BumpBiodatabaseIds < ActiveRecord::Migration
  def self.up
    # THIS  is a total hack to make the biodatabase ids not conflict with biodatabase_group ids...
    sql = <<-EOSQL
       INSERT INTO biodatabases
         (`id`, `name`, `authority`, `description`, `biodatabase_type_id`, `biodatabase_group_id`, `fasta_file_id`, `user_id`, `created_at`, `updated_at`)
       VALUES
         ('990000', 'TEMPRECORD', NULL, NULL, '0', '0', '0', '0', NULL, NULL)
    EOSQL
    begin
      Biodatabase.connection.insert(sql)
    rescue => e
      puts "Error bumping db ID, no big deal"
    end
  end

  def self.down
  end
end
