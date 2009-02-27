require 'erb'

Capistrano::Configuration.instance(:must_exist).load do
  after "deploy:update_code", "capinatra:config"
  
  namespace :capinatra do
    desc "Copies the Rack configuration template to the current directory (useful if you want to override behavior)"
    task :copy_config do
      require 'fileutils'
      FileUtils.cp File.join(File.dirname(__FILE__), '..', 'templates', 'config.ru.erb'), File.join(Dir.pwd, 'config.ru.erb')
    end
    
    desc "Sets up apache vhost"
    task :vhost do
      logger.info 'compiling vhost template'
      template = File.read(File.join(File.dirname(__FILE__), '..', 'templates', 'vhost.conf.erb'))

      logger.info 'uploading vhost file'
      put ERB.new(template).result(binding), "#{application}.conf"

      logger.info 'moving vhost file to ' + apache_vhost_dir
      sudo "mv #{application}.conf #{apache_vhost_dir}"

      logger.info 'restarting apache'
      sudo "sudo apache2ctl graceful"
    end
    
    desc "Adds config.ru file"
    task :config do
      template = File.read(File.join(File.dirname(__FILE__), '..', 'templates', 'config.ru.erb'))
      if File.exist?(File.join(Dir.pwd, 'config.ru.erb'))
        template = File.join(Dir.pwd, 'config.ru.erb')
        logger.info 'using custom Rack configuration template'
      else
        logger.info 'using supplied Rack configuration template'
      end
      
      logger.info 'compiling config.ru template'
      put ERB.new(template).result(binding), "config.ru"

      logger.info 'uploading config.ru file'

      logger.info 'moving config.ru file to ' + release_path
      sudo "mv config.ru #{release_path}"
    end
  end
end