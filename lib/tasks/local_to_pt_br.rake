require './config/environment'
# This task should
namespace :cominutas do
  task :local_to_pt_br do
    
    desc "Run this once to update organization to pt-BR"
    puts "Following this guide: https://docs.decidim.org/en/v0.27/develop/fixing_locales.html"
    
    puts "Updating organization locale's to pt-BR"
    org = Decidim::Organization.first
    org.available_locales = ["pt-BR"]
    org.default_locale = "pt-BR"
    org.save!
    puts "updated locale to #{org.available_locales.to_s}"
    puts "updated locale to #{org.default_locale}"
    
    puts "Synchronizing all locales"
    Rake::Task["decidim:locales:sync_all"].invoke
    puts "rebuilding search index"
    Rake::Task["decidim:locales:rebuild_search"].invoke
  end
end
