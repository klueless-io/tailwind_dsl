# Boot Sequence

include KLog::Logging

CONFIG_KEY = :tailwind_dsl

log.kv 'working folder', Dir.pwd

KConfig.configure do |config|
  config.handlebars.defaults.add_all_defaults
end

def k_builder
  @k_builder ||= KBuilder::BaseBuilder.init(KConfig.configuration(CONFIG_KEY))
end

KConfig.configure(CONFIG_KEY) do |config|
  builder_folder    = Dir.pwd
  base_folder       = File.expand_path('../', builder_folder)
  global_template   = File.expand_path('~/dev/kgems/k_templates/templates')

  config.template_folders.add(:global_template    , global_template)
  config.template_folders.add(:template           , File.expand_path('.templates', Dir.pwd))

  config.target_folders.add(:app                  , base_folder)
  config.target_folders.add(:lib                  , :app, 'lib', 'tailwind_dsl')
  config.target_folders.add(:spec                 , :app, 'spec', 'tailwind_dsl')
  config.target_folders.add(:docs                 , :app, 'docs')
  config.target_folders.add(:builder              , builder_folder)

  config.target_folders.add(:template_merakiui    , global_template, 'tailwind', 'merakiui')
  config.target_folders.add(:template_devdojo     , global_template, 'tailwind', 'devdojo')
  config.target_folders.add(:template_tui         , global_template, 'tailwind', 'tui')
end

KConfig.configuration(CONFIG_KEY).debug

area = KManager.add_area(CONFIG_KEY)
resource_manager = area.resource_manager
resource_manager
  .fileset
  .glob('*.rb', exclude: ['boot.rb'])
  .glob('generators/**/*.rb')
resource_manager.add_resources

KManager.boot
