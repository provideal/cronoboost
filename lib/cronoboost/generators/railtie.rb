module ActiveModel
  class Railtie < Rails::Railtie
    initializer 'generators' do |app|
      require 'cronoboost/generators/cronoboost/install_generator'
      Rails::Generators.configure!(app.config.generators)
    end
  end
end
