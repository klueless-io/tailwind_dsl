require 'gpt3/builder'

KManager.action :utilities do
  helpers = self

  action do
    KDirector::Dsls::BasicDsl
      .init(k_builder,
        template_folder:            '',
        on_exist:                   :write,                      # %i[skip write compare]
        on_action:                  :execute)                    # %i[queue execute]
      .blueprint(name: :build_design_system) do
        cd(:data)

        # Raw components are source HTML/Tailwind files that have embedded information such as tailwind.config.js and usage instructions
        source_component_path = File.expand_path('~/dev/kgems/k_templates/templates/tailwind')

        # Target components are the processed components that are ready to be consumed by the TailwindDSL
        target_component_path = k_builder.target_folders.get(:components)
        
        # The component data shapes are reflected model based on the data inside of a HTML templates
        target_component_model_path = k_builder.target_folders.get(:component_models)

        # Builds the design_system.json by reading all the HTML templates for every UIKit found the source_component_path
        uikit = helpers.load_design_systems(source_component_path)

        add('design_system.json', content: JSON.pretty_generate(uikit.to_h))

        # Separate clean and raw components, tailwind configuration, settings into their own folders
        component_generator = helpers.generate_components(uikit, source_component_path, target_component_path, reset_root_path: false)
        components = component_generator.components

        # Use GPT3 to extract component models in supervised fashion
        helpers.batch_extraction(
          components,
          target_component_model_path,
          batch_size: 1,
          use_prompt: true,
          filter_design_system: 'tui',
          extract_handler: TailwindDsl::Etl::Extractors::DataExtractor
        )
        # puts target_component_path
        # /Users/davidcruwys/dev/kgems/tailwind_dsl/.components

        # Goals
        #   - Generate a Tailwind component complete design system so that I can see both the component plus the original source code
        #     [✔️] There should be a deep hierarchy of folders and files in a menu structure
        #     When you click on a menu item, there should be a preview of the component
        #     The menus should be collapsible
        #     The menus should be searchable
        #     The component should have link to the original Tailwind component
        #     The component should show tailwind config if it exists
        #     The component should show the data shape if it exists
        #     The component should show the Astro component if it exists
        #   - Generate a Data Structure JSON file for each component (one at a time, so just the next component using GPT3)
        #   - Bulk training of GPT3 to generate a Data Structure JSON file after every 5 to 10 new components
      end

  end

  def load_design_systems(source_component_path)
    loader = TailwindDsl::Etl::RawComponents::Load.new

    loader.add_design_system(File.join(source_component_path, 'tui'))
    # loader.add_design_system(File.join(source_component_path, 'codepen'))
    # loader.add_design_system(File.join(source_component_path, 'devdojo'))
    # loader.add_design_system(File.join(source_component_path, 'merakiui'))
    # loader.add_design_system(File.join(source_component_path, 'noq'))
    # loader.add_design_system(File.join(source_component_path, 'starter-kit'))
    loader.uikit
  end

  def generate_components(uikit, source_component_path, target_folder, reset_root_path: false)
    generator = TailwindDsl::Etl::ComponentStructures::Generator.new(uikit, source_component_path, target_folder, reset_root_path: reset_root_path)
    generator.generate
    generator
  end

  # Extracts the next component data using GPT3
  #
  # This needs to be supervised and verified, so it will only do a few models at a time
  def batch_extraction(components, target_folder, batch_size: 1, use_prompt: false, filter_design_system: nil, extract_handler: nil)
    extraction = TailwindDsl::Etl::Extractors::BatchExtraction.new(
      components,
      target_folder,
      batch_size: batch_size,
      use_prompt: use_prompt,
      filter_design_system: filter_design_system,
      extract_handler: extract_handler)
    extraction.extract
  end
end

KManager.opts.sleep = 2
