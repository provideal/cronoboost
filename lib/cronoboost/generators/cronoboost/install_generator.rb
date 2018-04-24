class InstallGenerator < Rails::Generators::Base
  desc 'initialize cronoboost'
  source_root File.expand_path('../templates', __FILE__)

  def copy_translation_file
    copy_file 'cronoboost_initializer.rb', 'config/initializers/cronoboost.rb'
    copy_file 'cronoboost_setup.rb', 'Cronofile'
  end
end
