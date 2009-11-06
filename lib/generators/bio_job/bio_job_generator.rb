# To change this template, choose Tools | Templates
# and open the template in the editor.

class BioJobGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions "Jobs::#{class_name} #{file_name}"
      m.template 'bio_job.rb', "lib/jobs/#{file_name}.rb"
#      m.directory('public/stylesheets')
#      m.file('application.css', 'public/stylesheets/application.css')
    end
  end

end
