KManager.action :domain_model do
  action do

    DrawioDsl::Drawio
      .init(k_builder, on_exist: :write, on_action: :execute)
      .diagram(theme: :style_04)
      .page('Domain Modal', margin_left: 0, margin_top: 0, rounded: 0, background: '#fafafa') do
        grid_layout(wrap_at: 6, grid_w: 220, grid_h: 180)

        group(title: 'Tailwind GEM', theme: :style_01) 

        group(title: 'Configuration', theme: :style_01) 

        klass(:a1, w: 200) do
          format
            .header('Configuration', namespace: :config, description: 'Configuration container for the Tailwind DSL')
            .field(:collections       , type: :Collections)      # winter, summer
            .field(:themes            , type: :Themes)           # light, dark, red, blue
            .field(:data_shapes       , type: :DataShapes)       # obj, heading_paragraph_list, image_heading_paragraph_list
            .field(:component_groups  , type: :ComponentGroups)  # nav, footer, header, hero, price
        end

        # A Collection would be better named as a UIKit or DesignSystem
        klass(:a2, w: 200) do
          format
            .header('Collection', namespace: :config, description: 'Configuration for collection of Tailwind components. AKA uikit / brands / set / design')
            .field(:name, type: :String)
            .field(:description, type: :String)
            .field(:component_groups  , type: :ComponentGroups)  # winter, summer
            .field(:default_themes    , type: :Themes)           # light, dark
        end

        klass(:a3, w: 200, description: 'Configuration for theme', note: 'light, dark, red, green') do
          format
            .header('Theme', namespace: :config)
            .field(:key, type: :Symbol)
            .field(:name, type: :String) # The name will default to the titleized version of the key
            .field(:description, type: :String)
        end

        klass(:a4, w: 200, description: 'Configuration for data shape', note: 'object, key_value array') do
          format
            .header('DataShape')
            .field(:key, type: :Symbol)
            .field(:name, type: :String)
            .field(:description, type: :String)
        end

        klass(:a5, w: 200) do
          format
            .header('ComponentGroup', namespace: :config, description: 'Configuration for component group. [nav, footer, header, hero, price]')
            .field(:key, type: :Symbol)
            .field(:name, type: :String)
            .field(:description, type: :String)
            .field(:collection, type: :Collection) # belongs_to (foreign_key)
            .field(:components  , type: :Components)   # 01, 02, 03
        end

        klass(:a6, w: 200, description: 'Configuration for component', note: '01, 02, 03') do
          format
            .header('Component', namespace: :config)
            .field(:key, type: :Symbol)
            .field(:name, type: :String)
            .field(:description, type: :String)
            .field(:data_shape, type: :DataShape)
        end

        solid(source: :a1, target: :a2, exit_point: :e, entry_point: :w, waypoint: :orthogonal_curved)
        solid(source: :a1, target: :a3, exit_point: :e, entry_point: :w, waypoint: :orthogonal_curved)
        solid(source: :a1, target: :a4, exit_point: :e, entry_point: :w, waypoint: :orthogonal_curved)
        solid(source: :a1, target: :a5, exit_point: :e, entry_point: :w, waypoint: :orthogonal_curved)
        solid(source: :a5, target: :a6, exit_point: :e, entry_point: :w, waypoint: :orthogonal_curved)
        solid(source: :a6, target: :a4, exit_point: :w, entry_point: :e, waypoint: :orthogonal_curved)
        solid(source: :a2, target: :a3, exit_point: :w, entry_point: :e, waypoint: :orthogonal_curved)

        group(title: 'Schema', theme: :style_01) 

        # website -> root<Page> (start of sitemap)
        #         -> page -> pages [about, contact, news, products, services, terms, privacy] -> news -> news_item
        #         -> page -> components -> component -> data_shape

        klass(:b1, w: 200, description: '') do
          format
            .header('WebSite', namespace: :schema)
            .field(:key, type: :Symbol)
            .field(:name, type: :String)
            .field(:description, type: :String)
            .field(:target_folder, type: :String)
            .field(:base_collection, type: :Collection) # belongs_to (foreign_key)
            .field(:theme, type: :Theme)  # belongs_to (foreign_key)
            .field(:root, type: :Page)
            .method(:favourite_components, type: :Components) # these are the components have been used in the site and implicitly become favourite
        end

        klass(:b2, w: 200, description: '') do
          format
            .header('Page', namespace: :schema)
            .field(:key, type: :Symbol)
            .field(:name, type: :String)
            .field(:description, type: :String)
            .field(:sub_folder, type: :String)
            .field(:level, type: :Integer) # level 1 will hold root (home page) and top level pages (about, contact, etc)
            .field(:pages, type: :Pages)   # 01, 02, 03
            .field(:components, type: :Components)   # 01, 02, 03
        end

        klass(:b3, w: 200, description: '') do
          format
            .header('Component', namespace: :schema)
            .field(:key, type: :Symbol)
            .field(:name, type: :String)
            .field(:description, type: :String)
            .field(:component_group, type: :ComponentGroup) # belongs_to (foreign_key)
            .field(:data_shape, type: :DataShape)
        end

        solid(source: :b1, target: :b2, exit_point: :e, entry_point: :w, waypoint: :orthogonal_curved)
        solid(source: :b2, target: :b3, exit_point: :e, entry_point: :w, waypoint: :orthogonal_curved)
        solid(source: :b2, target: :b2, exit_point: :e, entry_point: :s, waypoint: :orthogonal_curved)

        group(title: 'Tailwind Generator', theme: :style_01)

        # MVC pattern
        # Model (data shape) -> View (component html) -> Controller (tailwind generator)

        group(title: 'Tailwind DSL', theme: :style_01)

        klass(w: 200, description: 'DSL for tailwind websites') do
          format
            .header('TailwindDsl')
            .method(:website)
            .method(:page)
            .method(:component)
            .method(:save)
        end

        group(title: 'DataBuilder', theme: :style_01)

        klass(w: 200, description: 'Base for any Data Builder') do
          format
            .header('BaseDataBuilder')
            .field(:obj, type: :Hash)
        end

        # page('home') do
        #   component('nav') do
        #     data
        #       .logo('xmen.png')
        #       .menu('About', 'about.html')
        #       .menu('Contact', 'contact.html')
        #       .menu('News', 'news.html')
        #   end

        interface(description: 'Create an instance of a DataBuilder for the target component', theme: :style_02) do
          format
            .header('Factory', interface_type: 'MixIn')
            .method(:data)
            .method(:data_instance)
        end

        temp_suffix = 'X' # turn this on when generating code to avoid folder name collision
        # Transformers
        klass(:c1, w: 200) do
          format
            .header('Root'                , namespace: "#{temp_suffix}Transformers::RawComponents",
                                            description: 'Root container for normalizing the raw Tailwind html in component data structures',
                                            dry_struct: true)
            .field(:design_systems        , type: "Types::Strict::Array.of(DesignSystem)")
        end

        klass(:c2, w: 200) do
          format
            .header('DesignSystem', namespace: "#{temp_suffix}Transformers::RawComponents",
                                            description: 'DesignSystem represents a collection of Tailwind CSS components that follow a specific design system',
                                            dry_struct: true)
            .field(:name                  , type: 'Types::Strict::String')
            .field(:path                  , type: 'Types::Strict::String')
            .field(:stats                 , type: 'Types::Strict::Hash')
            .field(:groups                , type: "Types::Strict::Array.of(Group)")
        end

        klass(:c3, w: 200) do
          format
            .header('Group'               , namespace: "#{temp_suffix}Transformers::RawComponents",
                                            description: 'Group represents a collection of Tailwind CSS components withing a named group or category',
                                            dry_struct: true)
            .field(:key                   , type: 'Types::Strict::String')
            .field(:type                  , type: 'Types::Strict::String')
            .field(:folder                , type: 'Types::Strict::String')
            .field(:sub_keys              , type: "Types::Array.of(Types::Strict:'Types::Strict::String')")
            .field(:files                 , type: "Types::Strict::Array.of(SourceFile)")
        end

        klass(:c4, w: 200) do
          format
            .header('SourceFile'          , namespace: "#{temp_suffix}Transformers::RawComponents",
                                            description: 'SourceFile represents a list of source files that contain raw Tailwind CSS components',
                                            dry_struct: true)
            .field(:name                  , type: 'Types::Strict::String')
            .field(:file_name             , type: 'Types::Strict::String')
            .field(:file_name_only        , type: 'Types::Strict::String')
            .field(:absolute_file         , type: 'Types::Strict::String')
            .field(:file                  , type: 'Types::Strict::String')
            .field(:target                , type: "TailwindDsl::#{temp_suffix}Transformers::RawComponents::TargetFile")
        end

        klass(:c5, w: 200) do
          format
            .header('TargetFile'          , namespace: "#{temp_suffix}Transformers::RawComponents",
                                            description: 'TargetFile represents each sub_file that can be built from a source file, such as HTML Component, Tailwind Config, Settings and Data Structure',
                                            dry_struct: true)
            .field(:html_file             , type: 'Types::Strict::String')
            .field(:clean_html_file       , type: 'Types::Strict::String')
            .field(:tailwind_config_file  , type: 'Types::Strict::String')
            .field(:settings_file         , type: 'Types::Strict::String')
            .field(:data_file             , type: 'Types::Strict::String')
            .field(:astro_file            , type: 'Types::Strict::String')
        end

        solid(source: :c1, target: :c2, exit_point: :e, entry_point: :w, waypoint: :orthogonal_curved)
        solid(source: :c2, target: :c3, exit_point: :e, entry_point: :w, waypoint: :orthogonal_curved)
        solid(source: :c3, target: :c4, exit_point: :e, entry_point: :w, waypoint: :orthogonal_curved)
        solid(source: :c4, target: :c5, exit_point: :e, entry_point: :w, waypoint: :orthogonal_curved)

      end
      .cd(:docs)
      .save('domain-model.drawio')
      .save_json('domain-model')
      .export_svg('domain-model', page: 1)
  end
end

KManager.opts.app_name                    = 'tailwind_domain_model'
KManager.opts.sleep                       = 2
KManager.opts.reboot_on_kill              = 0
KManager.opts.reboot_sleep                = 4
KManager.opts.exception_style             = :long
KManager.opts.show.time_taken             = true
KManager.opts.show.finished               = true
KManager.opts.show.finished_message       = 'FINISHED :)'
