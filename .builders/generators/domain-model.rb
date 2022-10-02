KManager.action :domain_model do
  action do

    DrawioDsl::Drawio
      .init(k_builder, on_exist: :write, on_action: :execute)
      .diagram(theme: :style_04)
      .page('Domain Modal', margin_left: 0, margin_top: 0, rounded: 0, background: '#fafafa') do
        grid_layout(wrap_at: 6, grid_w: 220, grid_h: 180)

        group(title: 'Tailwind GEM', theme: :style_01) 

        group(title: 'Configuration', theme: :style_01) 

        klass(:a1, w: 200, description: 'Configuration container for the Tailwind DSL') do
          format
            .header('Configuration', namespace: :config)
            .field(:collections       , type: :Collections)      # winter, summer
            .field(:themes            , type: :Themes)           # light, dark, red, blue
            .field(:data_shapes       , type: :DataShapes)       # obj, heading_paragraph_list, image_heading_paragraph_list
            .field(:component_groups  , type: :ComponentGroups)  # nav, footer, header, hero, price
        end

        klass(:a2, w: 200, description: 'Configuration for collection', note: 'other words could be - brands / set / design / collection') do
          format
            .header('Collection', namespace: :config)
            .field(:more, type: :String)
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

        klass(:a5, w: 200, description: 'Configuration for component group', note: 'nav, , footer, header, hero, price') do
          format
            .header('ComponentGroup', namespace: :config)
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
