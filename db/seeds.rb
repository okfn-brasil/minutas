password = "decidim12345678"

include Decidim::TranslationsHelper

smtp = {
  label: ENV.fetch("SMTP_FROM_LABEL", "Open Knowledge Brasil"),
  email: ENV.fetch("SMTP_FROM_EMAIL", "noreply@ok.org.br"),
  user: ENV.fetch("SMTP_USERNAME", "okfnbr"),
  pass: ENV.fetch("SMTP_PASSWORD", password),
  host: ENV["SMTP_ADDRESS"] || ENV["DECIDIM_HOST"] || "localhost",
  port: ENV["SMTP_PORT"] || ENV["DECIDIM_SMTP_PORT"] || "25",
}

system = Decidim::System::Admin.first || Decidim::System::Admin.create!(
  email: "system@example.org",
  password: password,
  password_confirmation: password,
)

organization = Decidim::Organization.first || Decidim::Organization.create!(
  name: "cominutas",
  twitter_handler: "okfnbr",
  instagram_handler: "openknowledgebrasil",
  github_handler: "okfn-brasil",
  smtp_settings: {
    from: "#{smtp[:label]} <#{smtp[:email]}>",
    from_email: smtp[:email],
    from_label: smtp[:label],
    user_name: smtp[:user],
    encrypted_password: Decidim::AttributeEncryptor.encrypt(smtp[:pass]),
    address: smtp[:host],
    port: smtp[:port],
  },
  host: ENV.fetch("DECIDIM_HOST", "localhost"),
  secondary_hosts: ENV.fetch("DECIDIM_HOST", ["0.0.0.0", "127.0.0.1"]),
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
  omnipresent_banner_title: {"pt": "Aviso"},
  omnipresent_banner_short_description: {"pt": "Aqui vão os avisos da plataforma sobre minutas mais recentes, status de operações no site, etc."},
)

Decidim::System::CreateDefaultContentBlocks.call(organization)

hero = Decidim::ContentBlock.find_by(
  organization: organization,
  manifest_name: :hero,
  scope_name: :homepage,
)

hero.images_container.background_image = ActiveStorage::Blob.create_and_upload!(
  io: File.open(Rails.root.join("assets", "hero-cominutas.png")),
  filename: "hero-cominutas.png",
  content_type: "image/jpeg",
  metadata: nil,
)

hero.settings = { "welcome_text_pt": "governo aberto colaborativo" }

hero.save!

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
  admin_terms_accepted_at: Time.current
)

# Create a new process:
#
#  title:            Política de Dados Abertos do Município
#  subtitle:         A prefeita de um município mais transparente decreta
#  position:         0
#  url:              politica-de-dados-abertos
#  short:            Minuta colaborativa para os municípios
#  description:      ...
#  registration:     register & login
#
# Create a new assembly:
#
#  title:            Reunião
#  subtitle:         Teste
#  position:         0
#  url:              teste-reuniao
#  short:            ...
#  description:      ...
#  registration:     register & login
#
# Edit the appearance of the an organization:
#
#  - Enable omnipresent banner.
#  - Add favicon & logos.
#  - Set URL → https://ok.org.br
#  - Colors: { $primary: #D27DF8, $secondary: #6472E0 }
#
# Change the homepage layout:
#
#  - Hero (set image).
#  - Sub-hero.
#  - Highlighted content.
#  - How to participate.
#  - Highlighted processes (max: 4).
#  - Footer sub-hero.
#  - Upcoming meetings.
