KManager.action :domain_model_to_code do
  action do
    director = KDirector::Dsls::RubyGemDsl
      .init(k_builder,
        template_base_folder:       'ruby/components/drawio_diagram',
        on_exist:                   :skip,                      # %i[skip write compare]
        on_action:                  :queue                      # %i[queue execute]
      )
      .data(
      )
      .blueprint(
        active: true,
        name: :build_domain,
        description: 'Build the domain classes and tests based on the domain model',
        on_exist: :skip) do

        domain_model_list = domain_model.take(11)

        domain_model_list.each do |code_block|
          if code_block[:block_type] == 'klass'
            klass = code_block[:items].select { |item| item[:type] == 'class' }.first
            namespaces = snake.parse(klass[:namespace]).to_s.split('::')
            model = {
              name: klass[:name],
              description: klass[:description],
              namespaces: [:tailwind_dsl] + namespaces,
              fields: code_block[:items].select { |item| item[:type] == 'field' }.map { |item| { name: item[:name], type: item[:type] } },
              methods: code_block[:items].select { |item| item[:type] == 'method' }.map { |item| { name: item[:name], type: item[:type] } }
            }

            cd(:lib)
            add(output_file_name(namespaces, klass[:name]), template_file: 'class.rb', model: model)
            cd(:spec)
            add(output_file_name(namespaces, klass[:name], suffix: '_spec'), template_file: 'class_spec.rb', model: model)
          end
        end

        require_paths = domain_model_list.map { |code_block|
          klass = code_block[:items].select { |item| item[:type] == 'class' }.first
          namespaces = snake.parse(klass[:namespace]).to_s.split('::')
          full_namespace = [:tailwind_dsl] + namespaces + [snake.parse(klass[:name])]
          full_namespace.join('/')
        }

        cd(:lib)
        add('../_.rb', template_file: 'requires.rb', require_paths: require_paths)

        run_command('rubocop -a')

        # puts JSON.pretty_generate(domain_model)
        # add('.gitignore')
      end

    director.play_actions
    # director.builder.logit
  end
end

@domain_model = nil

def domain_model
  @domain_model ||= begin
    file = k_builder.target_folders.get_filename(:docs, 'domain-model.json')
    hash = JSON.parse(File.read(file), symbolize_names: true)

    domain_page = hash[:pages].first
    page_node = domain_page[:nodes].first
    root_node = page_node[:nodes].first
    code_blocks = root_node[:nodes].select { |node| node[:key] == 'klass' || node[:key] == 'interface' }
    # puts JSON.pretty_generate(code_blocks)
    # todo: post process to code block items to handle deep namespaces if needed
    code_blocks.map do |code_block|
      {
        block_type: code_block[:key],
        items: code_block[:meta_data][:items]
      }
    end
  end
end

def output_file_name(namespaces, name, suffix: '', extension: 'rb')
  name = snake.parse(name)

  file_name = "#{name}#{suffix}.#{extension}"
  file_parts = namespaces.reject(&:empty?)
  file_parts << file_name
  file_parts.join('/')
end

KManager.opts.app_name                    = 'domain_model_to_code'
KManager.opts.sleep                       = 2
KManager.opts.reboot_on_kill              = 0
KManager.opts.reboot_sleep                = 4
KManager.opts.exception_style             = :short
KManager.opts.show.time_taken             = true
KManager.opts.show.finished               = true
KManager.opts.show.finished_message       = 'FINISHED :)'
