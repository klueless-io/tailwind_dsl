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

        design_systems = helpers.build_design_systems
        json = JSON.pretty_generate(design_systems.to_h)

        add('design_system.json', content: json)

        component_folder = k_builder.target_folders.get(:components)

        # helpers.generate_components(graph, component_folder, reset_root_path: false) # HAVE NOT TESTED THIS YET

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

  def build_design_systems
    source_path = File.expand_path('~/dev/kgems/k_templates/templates/tailwind')

    director = TailwindDsl::Transformers::RawComponents::Director.new

    director.add_design_system(File.join(source_path, 'tui'))
    # director.add_design_system(File.join(source_path, 'codepen'))
    # director.add_design_system(File.join(source_path, 'devdojo'))
    # director.add_design_system(File.join(source_path, 'merakiui'))
    # director.add_design_system(File.join(source_path, 'noq'))
    # director.add_design_system(File.join(source_path, 'starter-kit'))
    director.design_systems
  end

  def generate_components(graph, target_folder, reset_root_path: false)
    generator = TailwindDsl::RawComponents::GenerateComponentStructures.new(graph, target_folder, reset_root_path: reset_root_path)
    generator.generate
  end
end
KManager.opts.sleep = 2
