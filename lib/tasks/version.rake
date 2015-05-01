namespace :responsys_rest do
  desc 'Output App Version'
  task :version do
    puts Rails.configuration.app_version
  end
end
