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
        raw_component_path = File.expand_path('~/dev/kgems/k_templates/templates/tailwind')

        # Target components are the processed components that are ready to be consumed by the TailwindDSL
        component_folder = k_builder.target_folders.get(:components)

        uikit = helpers.build_design_systems(raw_component_path)
        json = JSON.pretty_generate(uikit.to_h)

        add('design_system.json', content: json)

        helpers.generate_components(uikit, raw_component_path, component_folder, reset_root_path: false)

        # Goals
        #   - Generate a Tailwind component complete design system so that I can see both the component plus the original source code
        #     There should be a deep hierarchy of folders and files in a menu structure
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

  def build_design_systems(raw_component_path)
    director = TailwindDsl::Etl::RawComponents::Director.new

    director.add_design_system(File.join(raw_component_path, 'tui'))
    # director.add_design_system(File.join(raw_component_path, 'codepen'))
    # director.add_design_system(File.join(raw_component_path, 'devdojo'))
    # director.add_design_system(File.join(raw_component_path, 'merakiui'))
    # director.add_design_system(File.join(raw_component_path, 'noq'))
    # director.add_design_system(File.join(raw_component_path, 'starter-kit'))
    director.uikit
  end

  def generate_components(uikit, raw_component_path, target_folder, reset_root_path: false)
    generator = TailwindDsl::Etl::ComponentStructures::Generator.new(uikit, raw_component_path, target_folder, reset_root_path: reset_root_path)
    generator.generate
  end
end
KManager.opts.sleep = 2
