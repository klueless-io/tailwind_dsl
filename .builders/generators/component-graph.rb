KManager.action :component_graph do
  action do
    director = KDirector::Dsls::BasicDsl
      .init(k_builder,
        template_folder: '',
        on_exist:                   :write,                      # %i[skip write compare]
        on_action:                  :execute                     # %i[queue execute]
      )


    component_raw_path = director.k_builder.target_folders.get(:components_raw)
    # component_target_path = director.k_builder.target_folders.get(:components)
    
    raw = build_raw_graph(component_raw_path, :sample)

    puts raw
  end

  def raw_graph_reject(entry)
    puts entry

    entry.end_with?('all.html') ||
      entry.end_with?('all.json') ||
      entry.end_with?('all-component-menu.html') ||
      entry.end_with?('all-components.txt') ||
      entry.end_with?('all-components.json') ||
      entry.end_with?('all-components.csv') ||
      entry.end_with?('.txt')
  end
  
  def d
    @die = true
    exit
  end

  def build_raw_graph(path, design_system)
    return 
    design_system = design_system.to_s
    base_path = File.join(path, design_system)

    glob = File.join(base_path, '**', '*')

    groups = []

    result = {
      design_system: design_system,
      groups: groups
    }



    @die = false
    current_group = {}

    Dir.glob(glob) do |entry|
      next if @die
      next if raw_graph_reject(entry)

      relative_path = Pathname.new(entry).relative_path_from(Pathname.new(base_path)).to_s

    end

    groups.each do |group|
      group[:files].sort_by! { |file| file[:name] }
    end
  
    {
      groups: groups
    }
  end
end
KManager.opts.sleep                       = 2
