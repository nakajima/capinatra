require 'erb'

Capistrano::Configuration.instance(:must_exist).load do
  after "deploy:update_code", "capinatra:config"
  
  namespace :capinatra do
    desc "Sets up apache vhost"
    task :vhost do
      logger.info 'compiling vhost template'
      template = File.read(File.dirname(__FILE__), '..', 'templates', 'vhost.conf.erb')

      logger.info 'uploading vhost file'
      put ERB.new(template).result(binding), "#{application}.conf"

      logger.info 'moving vhost file to ' + apache_vhost_dir
      sudo "mv #{application}.conf #{apache_vhost_dir}"

      logger.info 'restarting apache'
      sudo "sudo apache2ctl graceful"
    end
    
    desc "Adds config.ru file"
    task :config do
      logger.info 'compiling config.ru template'
      template = File.read(File.dirname(__FILE__), '..', 'templates', 'config.ru.erb')

      logger.info 'uploading config.ru file'
      put ERB.new(template).result(binding), "config.ru"

      logger.info 'moving vhost file to ' + apache_vhost_dir
      sudo "mv config.ru #{current_path}"
    end
  end
  
  namespace :deploy do
    task :restart do
      run "touch #{current_path}/tmp/restart.txt"
    end
  end
end