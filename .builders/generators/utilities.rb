KManager.action :utilities do
  helpers = self
  action do
    director = KDirector::Dsls::BasicDsl
      .init(k_builder,
        template_folder: '',
        on_exist:                   :write,                      # %i[skip write compare]
        on_action:                  :execute                     # %i[queue execute]
      )
      .blueprint(name: :build_design_system) do
        cd(:data)

        helpers.build_design_system_graph(self)
      end
  end

  def build_design_system_graph(director)
    source_path = File.expand_path('~/dev/kgems/k_templates/templates/tailwind')
    target_path = File.join(director.k_builder.target_folders.get(:data), 'design_system.json')

    graph = TailwindDsl::RawComponents::ComponentGraph.new

    graph.add_design_system(source_path, name: :tui)
    graph.add_design_system(source_path, name: :codepen)
    graph.add_design_system(source_path, name: :devdojo)
    graph.add_design_system(source_path, name: :merakiui)
    graph.add_design_system(source_path, name: :noq)
    graph.add_design_system(source_path, name: "starter-kit")
    graph.write(target_path)
  end
end
KManager.opts.sleep                       = 2
