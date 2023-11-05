# Generates entries based on the design provided by okfbr.
#
# All the information is hard-coded.
# Please, rewrite if needed.
#
# See: assets/cominutas-mockup.pdf

password = "decidim123456789"

upload = ->(file) {
  ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("assets", file)),
    filename: file,
    content_type: "image/jpeg",
    metadata: nil,
  )
}

# Create the system administrator account.
system = Decidim::System::Admin.first || Decidim::System::Admin.create!(
  email: "system@example.org",
  password: password,
  password_confirmation: password,
)

# Setup an organization.
organization = Decidim::Organization.first || Decidim::Organization.create!(
  name: "cominutas",
  twitter_handler: "okfnbr",
  instagram_handler: "openknowledgebrasil",
  github_handler: "okfn-brasil",
  smtp_settings: {
    from: "Open Knowledge Brasil <noreply@ok.org.br>",
    from_email: "noreply@ok.org.br",
    from_label: "Open Knowledge Brasil",
    user_name: "okfnbr",
    encrypted_password: Decidim::AttributeEncryptor.encrypt(password),
    address: "localhost",
    port: "25",
  },
  host: "localhost",
  secondary_hosts: ["0.0.0.0", "127.0.0.1"],
  external_domain_whitelist: ["decidim.org", "github.com"],
  description: "",
  default_locale: "pt",
  available_locales: ["pt"],
  reference_prefix: "minutas",
  available_authorizations: Decidim.authorization_workflows.map(&:name),
  users_registration_mode: :enabled,
  tos_version: Time.current,
  badges_enabled: true,
  user_groups_enabled: true,
  send_welcome_notification: true,
  file_upload_settings: Decidim::OrganizationSettings.default(:upload),
  enable_omnipresent_banner: true,
  cta_button_text: {"pt"=>"participar"},
  cta_button_path: "pages/help",
  official_url: "https://ok.org.br",
  omnipresent_banner_url: "https://minutas.ok.org.br/pages/help",
  omnipresent_banner_title: {"pt": "Aviso"},
  omnipresent_banner_short_description: {"pt": "Aqui vão os avisos da plataforma sobre minutas mais recentes, status de operações no site, etc."},
)

# Add branding to the organization.
organization.favicon = upload.("favicon.png")
organization.logo = upload.("logo-cominutas.png")
organization.official_img_footer = upload.("logo-okbr.png")
organization.save!

# Create "terms & conditions" and "help" pages.
organization.static_pages ||
  Decidim::System::CreateDefaultPages.call(organization) &&
  Decidim::System::PopulateHelp.call(organization)

# Setup content blocks (layout) for the homepage.
blocks = [:hero,
          :sub_hero,
          :highlighted_content_banner,
          :how_to_participate,
          :highlighted_processes,
          :footer_sub_hero,
          :upcoming_meetings]

Decidim::ContentBlock.for_scope(:homepage, organization: organization).any? ||
  blocks.each_with_index do |manifest, index|
    Decidim::ContentBlock.create(
      decidim_organization_id: organization.id,
      weight: (index + 1) * 10,
      scope_name: :homepage,
      manifest_name: manifest,
      published_at: Time.current
    )
  end

# Set hero (banner) image.
hero = Decidim::ContentBlock.find_by(scope_name: :homepage,
                                     decidim_organization_id: organization.id,
                                     manifest_name: :hero)

hero.images_container.background_image = upload.("hero-cominutas.png")
hero.settings = { "welcome_text_pt": "governo aberto colaborativo" }
hero.save!

# Create an admin account for the organization.
admin = Decidim::User.first || Decidim::User.create!(
  email: "admin@example.org",
  name: "Admin",
  password: password,
  password_confirmation: password,
  nickname: "admin",
  organization: organization,
  confirmed_at: Time.current,
  locale: :pt,
  admin: true,
  tos_agreement: true,
  personal_url: "https://example.org",
  about: "...",
  accepted_tos_version: organization.tos_version + 1.hour,
  password_updated_at: Time.current,
  admin_terms_accepted_at: Time.current,
)

# Create sample processes.
cities = ['Rio de Janeiro', 'Recife', 'São Paulo']

Decidim::ParticipatoryProcess.count >= 3 ||
  cities.each_with_index do |city, index|
    Decidim::ParticipatoryProcess.create!(
      slug: "politica-de-dados-abertos-#{city.parameterize}",
      organization: organization,
      title: {"pt": "Decreto para instituição de Política de Dados Abertos do #{city}"},
      subtitle: {"pt": "A prefeita de um município mais transparente decreta"},
      short_description: {"pt": "<p>Minuta colaborativa para os municípios</p>"},
      description: {"pt": "<p>This is a long description</p>"},
      weight: (index + 1) * 10,
      published_at: Time.current,
      start_date: Time.current,
      hero_image: upload.("minuta-#{city.parameterize}.png"),
    )
  end
