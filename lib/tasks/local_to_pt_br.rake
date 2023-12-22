require './config/environment'
# This task should
namespace :cominutas do
  task :local_to_pt_br do
    
    desc "Run this once to update organization to pt-BR"
    puts "Following this guide: https://docs.decidim.org/en/v0.27/develop/fixing_locales.html"
    LANG = "pt-BR"
    puts "Updating organization locale's to #{LANG}"
    org = Decidim::Organization.first
    org.update!(
      available_locales: [LANG],
      default_locale: LANG,
      cta_button_text: {LANG =>"participar"},
      omnipresent_banner_title: {LANG => "Aviso"},
      omnipresent_banner_short_description: {LANG => "Aqui vão os avisos da plataforma sobre minutas mais recentes, status de operações no site, etc."}
    )
    
    puts "updated locale to #{org.available_locales.to_s}"
    puts "updated locale to #{org.default_locale}"
    puts "updating users locales to #{LANG}"
    Decidim::User.update_all locale: LANG.to_sym
    
    puts "Synchronizing all locales"
    Rake::Task["decidim:locales:sync_all"].invoke
    puts "rebuilding search index"
    Rake::Task["decidim:locales:rebuild_search"].invoke
  end
end
