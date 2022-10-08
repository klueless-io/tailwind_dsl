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

        graph = helpers.build_design_system_graph
        json = JSON.pretty_generate(graph.to_h)

        add('design_system.json', content: json)

        component_folder = k_builder.target_folders.get(:components)

        helpers.generate_components(graph, component_folder)
      end

  end

  def build_design_system_graph
    source_path = File.expand_path('~/dev/kgems/k_templates/templates/tailwind')

    graph = TailwindDsl::RawComponents::ComponentGraph.new

    graph.add_design_system(File.join(source_path, 'tui'))
    # graph.add_design_system(File.join(source_path, 'codepen'))
    # graph.add_design_system(File.join(source_path, 'devdojo'))
    # graph.add_design_system(File.join(source_path, 'merakiui'))
    # graph.add_design_system(File.join(source_path, 'noq'))
    # graph.add_design_system(File.join(source_path, 'starter-kit'))
    graph
  end

  def generate_components(graph, target_folder)
    generator = TailwindDsl::RawComponents::GenerateComponentStructures.new(graph, target_folder)
    generator.generate
  end
end
KManager.opts.sleep = 2
