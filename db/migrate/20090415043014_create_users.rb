class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string, :limit => 40
      t.column :name,                      :string, :limit => 100, :default => '', :null => true
      t.column :email,                     :string, :limit => 100
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime
      t.column :state,                     :string, :null => :no, :default => 'passive'
      t.column :deleted_at,                :datetime
    end
    add_index :users, :login, :unique => true
    User.create(:login => 'kenglish',
                :name  => 'Kevin English',
                :email => 'kenglish@gmail.com',
                :crypted_password => 'f1f2d888e1012fac645ed3ab108d5654f76c4550',
                :salt => '156ca62050a1c6a8df1ad6fb89dba5ce15b2989c' ,
                :activated_at => '2009-04-23 10:24:08',
                :state =>  'passive')

    User.create(:login => 'poissong',
                :name  => 'poisson',
                :email => 'guylaine@hawaii.edu',
                :crypted_password => 'd3cc86d420e51f1ebe1dce7077e908df97ec57ea',
                :salt => '11ab7010a700201ca9c0bd4b2907a910eef47cea' ,
                :activated_at => '2009-04-23 10:24:08',
                :state =>  'passive')
    
  end

  def self.down
    drop_table "user"
  end
end
