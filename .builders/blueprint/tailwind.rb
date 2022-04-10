KManager.model :tailwind, namespace: %i[domain] do
  # microapp = import(:handlebars_helpers, :microapp)

  # other settings
  # strokeWidth: 1-n
  # when there is an arrow at beginning
  # startFill=1,0
  # when there is an arrow at end
  # endFill=1,0

  table :collections do
    fields %i[key description default_themes source]

    row :devdojo    , 'DevDojo'   , %w[blue red green]
    row :merakiui   , 'Merakiui'  , %w[black white]       , 'https://github.com/merakiui/merakiui'
    row :start_kit  , 'start_kit' , %w[black white]
  end

  table :component_groups do
    fields %i[collection key description]

    row :devdojo, :nav
    row :devdojo, :hero
    row :devdojo, :header
    row :devdojo, :logo
    row :devdojo, :content
    row :devdojo, :footer
  end

  table :components do
    fields %i[component_group key data_shape name description]
    

    row :devdojo_nav        , :nav_01
    row :devdojo_nav        , :nav_02
    row :devdojo_nav        , :nav_03
    row :devdojo_nav        , :nav_04
    row :devdojo_hero       , :hero_01
    row :devdojo_hero       , :hero_02
    row :devdojo_hero       , :hero_03
    row :devdojo_hero       , :hero_04
    row :devdojo_content    , :fancy_paragraph, :fancy_paragraph
  end

  # Component - AKA: Template
  SAMPLE_TAILWIND = <<-HTML
    # Fancy Paragraph
    <div class="container mx-auto">
      <div class="flex flex-wrap">
        <div class="w-full md:w-1/2 p-6">
          <div class="{{bg}} rounded-lg shadow-lg p-6">
            <p class="{{fg}}">{{p}}</p>
          </div>
        </div>
      </div>
    </div>
  HTML

  TAILWIND_DSL = <<-RUBY
  tailwind = TailwindDsl
    .init
    .website(:test_site1,
      name: 'Test Site 1',
      description: 'This is our sample Test Site',
      target_folder: 'test_site1',
      base_collection: :devdojo,
      theme: :teal

    )
    .page(:home
      name: 'Home Page',
      description: 'This is the Home Page',
      child_pages(:about, :contact, :faq, :privacy, :articles) do

        nav(:nav_01)
        content(:fancy_paragraph) do
          data
            .p('The quick brown fox jumps over the lazy dog.')
            .color(bg: 'white', fg: 'black')
        end
    end
    .page(:about
      name: 'About Page',
      description: 'This is the About Page') do

      nav(:nav_01)
      content(:paragraph) do
        data
          .p('This is the about page')
      end
    end
    .page(:contact
      name: 'Contact Page',
      description: 'This is the Contact Page') do

      nav(:nav_01)
      content(:paragraph) do
        data
          .p('This is the contact page')
      end
    end
  RUBY

  SAMPLE_DATASHAPE_DSL_DEFINITION = <<-RUBY
  fancy_paragraph_definition = DataDsl
    .init(:fancy_paragraph)
    .requires(:p, default: 'The quick brown fox jumps over the lazy dog.')
    .requires(:color, defaults: { bg: 'white', fg: 'black' })
  RUBY

  SAMPLE_DATASHAPE_DSL = <<-RUBY
    fancy_paragraph = FancyParagraph
      .init
      .p('The quick brown fox jumps over the lazy dog.')
      .color(bg: 'white', fg: 'black')
  RUBY

  SAMPLE_DATASHAPE_JSON = <<-JSON
    {
      p: 'The quick brown fox jumps over the lazy dog.',
      bg: 'white',
      fg: 'black'
    }
  JSON

  # A datashape is a DSL definition for the data that is used to populate the tailwind component data
  table :data_shapes do
    fields %i[key name description]

    row :fancy_paragraph
  end

  table :themes do
    fields %i[favourite key bg_color font_color]

    # fields %i[key fill_color stroke_color font_color gradient]

    # row :style_01, '#f5f5f5', '#666666', '#333333'
    # row :style_02, '#dae8fc', '#6c8ebf', '#333333'

    # alternative source: https://www.quackit.com/css/css_color_codes.cfm
    # source: https://www.w3schools.com/colors/colors_hex.asp
    row 0, :navy                    , '#000080', '#FFFFFF'
    row 0, :dark_blue               , '#00008B', '#FFFFFF'
    row 0, :medium_blue             , '#0000CD', '#FFFFFF'
    row 0, :blue                    , '#0000FF', '#FFFFFF'
    row 0, :dark_green              , '#006400', '#FFFFFF'
    row 0, :green                   , '#008000', '#FFFFFF'
    row 1, :teal                    , '#008080', '#FFFFFF'
    row 0, :dark_cyan               , '#008B8B', '#FFFFFF'
    row 1, :deep_sky_blue           , '#00BFFF', '#FFFFFF'
    row 1, :dark_turquoise          , '#00CED1', '#FFFFFF'
    row 0, :medium_spring_green     , '#00FA9A', '#1F2D3D'
    row 0, :lime                    , '#00FF00', '#FFFFFF'
    row 0, :spring_green            , '#00FF7F', '#1F2D3D'
    row 0, :aqua                    , '#00FFFF', '#1F2D3D'
    row 0, :cyan                    , '#00FFFF', '#1F2D3D'
    row 0, :midnight_blue           , '#191970', '#FFFFFF'
    row 0, :dodger_blue             , '#1E90FF', '#FFFFFF'
    row 0, :light_sea_green         , '#20B2AA', '#FFFFFF'
    row 0, :forest_green            , '#228B22', '#FFFFFF'
    row 0, :sea_green               , '#2E8B57', '#FFFFFF'
    row 0, :dark_slate_gray         , '#2F4F4F', '#FFFFFF'
    row 0, :dark_slate_grey         , '#2F4F4F', '#FFFFFF'
    row 0, :lime_green              , '#32CD32', '#FFFFFF'
    row 0, :medium_sea_green        , '#3CB371', '#FFFFFF'
    row 0, :turquoise               , '#40E0D0', '#1F2D3D'
    row 1, :royal_blue              , '#4169E1', '#FFFFFF'
    row 1, :steel_blue              , '#4682B4', '#FFFFFF'
    row 0, :dark_slate_blue         , '#483D8B', '#FFFFFF'
    row 0, :medium_turquoise        , '#48D1CC', '#1F2D3D'
    row 0, :indigo                  , '#4B0082', '#FFFFFF'
    row 0, :dark_olive_green        , '#556B2F', '#FFFFFF'
    row 0, :cadet_blue              , '#5F9EA0', '#FFFFFF'
    row 1, :cornflower_blue         , '#6495ED', '#FFFFFF'
    row 0, :rebecca_purple          , '#663399', '#FFFFFF'
    row 0, :medium_aqua_marine      , '#66CDAA', '#1F2D3D'
    row 0, :dim_gray                , '#696969', '#FFFFFF'
    row 0, :dim_grey                , '#696969', '#FFFFFF'
    row 0, :slate_blue              , '#6A5ACD', '#FFFFFF'
    row 0, :olive_drab              , '#6B8E23', '#FFFFFF'
    row 0, :slate_gray              , '#708090', '#FFFFFF'
    row 0, :slate_grey              , '#708090', '#FFFFFF'
    row 0, :light_slate_gray        , '#778899', '#FFFFFF'
    row 0, :light_slate_grey        , '#778899', '#FFFFFF'
    row 0, :medium_slate_blue       , '#7B68EE', '#FFFFFF'
    row 0, :lawn_green              , '#7CFC00', '#1F2D3D'
    row 0, :chartreuse              , '#7FFF00', '#1F2D3D'
    row 0, :aquamarine              , '#7FFFD4', '#1F2D3D'
    row 0, :maroon                  , '#800000', '#FFFFFF'
    row 0, :purple                  , '#800080', '#FFFFFF'
    row 0, :olive                   , '#808000', '#FFFFFF'
    row 0, :gray                    , '#808080', '#FFFFFF'
    row 0, :grey                    , '#808080', '#FFFFFF'
    row 0, :sky_blue                , '#87CEEB', '#1F2D3D'
    row 0, :light_sky_blue          , '#87CEFA', '#1F2D3D'
    row 0, :blue_violet             , '#8A2BE2', '#FFFFFF'
    row 0, :dark_red                , '#8B0000', '#FFFFFF'
    row 0, :dark_magenta            , '#8B008B', '#FFFFFF'
    row 0, :saddle_brown            , '#8B4513', '#FFFFFF'
    row 1, :dark_sea_green          , '#8FBC8F', '#1F2D3D'
    row 0, :light_green             , '#90EE90', '#1F2D3D'
    row 0, :medium_purple           , '#9370DB', '#FFFFFF'
    row 0, :dark_violet             , '#9400D3', '#FFFFFF'
    row 0, :pale_green              , '#98FB98', '#1F2D3D'
    row 0, :dark_orchid             , '#9932CC', '#FFFFFF'
    row 0, :yellow_green            , '#9ACD32', '#1F2D3D'
    row 0, :sienna                  , '#A0522D', '#FFFFFF'
    row 0, :brown                   , '#A52A2A', '#FFFFFF'
    row 0, :dark_gray               , '#A9A9A9', '#1F2D3D'
    row 0, :dark_grey               , '#A9A9A9', '#1F2D3D'
    row 0, :light_blue              , '#ADD8E6', '#1F2D3D'
    row 0, :green_yellow            , '#ADFF2F', '#1F2D3D'
    row 0, :pale_turquoise          , '#AFEEEE', '#1F2D3D'
    row 1, :light_steel_blue        , '#B0C4DE', '#1F2D3D'
    row 0, :powder_blue             , '#B0E0E6', '#1F2D3D'
    row 1, :fire_brick              , '#B22222', '#FFFFFF'
    row 0, :dark_golden_rod         , '#B8860B', '#FFFFFF'
    row 0, :medium_orchid           , '#BA55D3', '#FFFFFF'
    row 1, :rosy_brown              , '#BC8F8F', '#1F2D3D'
    row 0, :dark_khaki              , '#BDB76B', '#1F2D3D'
    row 0, :silver                  , '#C0C0C0', '#1F2D3D'
    row 0, :medium_violet_red       , '#C71585', '#FFFFFF'
    row 1, :indian_red              , '#CD5C5C', '#FFFFFF'
    row 0, :peru                    , '#CD853F', '#FFFFFF'
    row 0, :chocolate               , '#D2691E', '#FFFFFF'
    row 1, :tan                     , '#D2B48C', '#1F2D3D'
    row 0, :light_gray              , '#D3D3D3', '#1F2D3D'
    row 0, :light_grey              , '#D3D3D3', '#1F2D3D'
    row 0, :thistle                 , '#D8BFD8', '#1F2D3D'
    row 0, :orchid                  , '#DA70D6', '#1F2D3D'
    row 0, :golden_rod              , '#DAA520', '#1F2D3D'
    row 0, :pale_violet_red         , '#DB7093', '#FFFFFF'
    row 0, :crimson                 , '#DC143C', '#FFFFFF'
    row 0, :gainsboro               , '#DCDCDC', '#1F2D3D'
    row 0, :plum                    , '#DDA0DD', '#1F2D3D'
    row 1, :burly_wood              , '#DEB887', '#1F2D3D'
    row 0, :light_cyan              , '#E0FFFF', '#1F2D3D'
    row 0, :lavender                , '#E6E6FA', '#1F2D3D'
    row 0, :dark_salmon             , '#E9967A', '#1F2D3D'
    row 0, :violet                  , '#EE82EE', '#1F2D3D'
    row 0, :pale_golden_rod         , '#EEE8AA', '#1F2D3D'
    row 0, :light_coral             , '#F08080', '#1F2D3D'
    row 0, :khaki                   , '#F0E68C', '#1F2D3D'
    row 0, :alice_blue              , '#F0F8FF', '#1F2D3D'
    row 0, :honey_dew               , '#F0FFF0', '#1F2D3D'
    row 0, :azure                   , '#F0FFFF', '#1F2D3D'
    row 0, :sandy_brown             , '#F4A460', '#1F2D3D'
    row 1, :wheat                   , '#F5DEB3', '#1F2D3D'
    row 0, :beige                   , '#F5F5DC', '#1F2D3D'
    row 0, :white_smoke             , '#F5F5F5', '#1F2D3D'
    row 0, :mint_cream              , '#F5FFFA', '#1F2D3D'
    row 0, :ghost_white             , '#F8F8FF', '#1F2D3D'
    row 0, :salmon                  , '#FA8072', '#1F2D3D'
    row 0, :antique_white           , '#FAEBD7', '#1F2D3D'
    row 1, :linen                   , '#FAF0E6', '#1F2D3D'
    row 1, :light_golden_rod_yellow , '#FAFAD2', '#1F2D3D'
    row 1, :pale_gray               , '#FAFAFA', '#1F2D3D'
    row 0, :pale_grey               , '#FAFAFA', '#1F2D3D'
    row 0, :old_lace                , '#FDF5E6', '#1F2D3D'
    row 0, :red                     , '#FF0000', '#FFFFFF'
    row 0, :fuchsia                 , '#FF00FF', '#FFFFFF'
    row 0, :magenta                 , '#FF00FF', '#FFFFFF'
    row 0, :deep_pink               , '#FF1493', '#FFFFFF'
    row 0, :orange_red              , '#FF4500', '#FFFFFF'
    row 0, :tomato                  , '#FF6347', '#FFFFFF'
    row 0, :hot_pink                , '#FF69B4', '#1F2D3D'
    row 0, :coral                   , '#FF7F50', '#1F2D3D'
    row 0, :dark_orange             , '#FF8C00', '#1F2D3D'
    row 0, :light_salmon            , '#FFA07A', '#1F2D3D'
    row 0, :orange                  , '#FFA500', '#1F2D3D'
    row 0, :light_pink              , '#FFB6C1', '#1F2D3D'
    row 0, :pink                    , '#FFC0CB', '#1F2D3D'
    row 0, :gold                    , '#FFD700', '#1F2D3D'
    row 1, :peach_puff              , '#FFDAB9', '#1F2D3D'
    row 0, :navajo_white            , '#FFDEAD', '#1F2D3D'
    row 0, :moccasin                , '#FFE4B5', '#1F2D3D'
    row 0, :bisque                  , '#FFE4C4', '#1F2D3D'
    row 0, :misty_rose              , '#FFE4E1', '#1F2D3D'
    row 0, :blanched_almond         , '#FFEBCD', '#1F2D3D'
    row 0, :papaya_whip             , '#FFEFD5', '#1F2D3D'
    row 0, :lavender_blush          , '#FFF0F5', '#1F2D3D'
    row 0, :sea_shell               , '#FFF5EE', '#1F2D3D'
    row 1, :cornsilk                , '#FFF8DC', '#1F2D3D'
    row 0, :lemon_chiffon           , '#FFFACD', '#1F2D3D'
    row 0, :floral_white            , '#FFFAF0', '#1F2D3D'
    row 1, :snow                    , '#FFFAFA', '#1F2D3D'
    row 0, :yellow                  , '#FFFF00', '#1F2D3D'
    row 0, :light_yellow            , '#FFFFE0', '#1F2D3D'
    row 1, :ivory                   , '#FFFFF0', '#1F2D3D'
  end

  action do
    return
    data = self.raw_data

    lookup = data['lines'] + data['texts'] + data['elements']

    content = {
      shape: {
        lookup: lookup.map { |shape| { key: shape['key'], category: shape['category'] } },
        elements: data['elements'],
        lines: data['lines'],
        texts: data['texts']
      },
      connector: {
        compass_points: data['connector_compass_points'],
        waypoints: data['connector_waypoints'],
        arrows: data['connector_arrows'],
        designs: data['connector_designs'],
      },
      theme: {
        elements: data['element_themes'],
        backgrounds: data['background_themes']
      },
      strokes: data['strokes']
    }

    k_builder
      .cd(:app)
      .add_file('config/configuration.json', content: JSON.pretty_generate(content), on_exist: :write)

    generate_code
  end
end

def generate_code
  shapes_file = k_builder.target_folders.get_filename(:app, 'config/configuration.json')
  shapes_configuration = JSON.parse(File.read(shapes_file))
  shapes = shapes_configuration['shape']
  lookup = shapes['lookup']
  elements = shapes['elements']
  lines = shapes['lines']
  texts = shapes['texts']

  # strokes = shapes_configuration['strokes']

  KDirector::Dsls::BasicDsl
    .init(k_builder,
      on_exist:                   :write,                      # %i[skip write compare]
      on_action:                  :execute                    # %i[queue execute]
    )
    .blueprint(
      active: true,
      on_exist: :write) do

      cd(:lib)

      add('schema/_.rb',
        template_file: 'schema_require.rb',
        elements: elements,
        lines: lines,
        texts: texts)

      elements.each do |element|
        add("schema/elements/#{element['key']}.rb",
          template_file: 'schema_element.rb',
          element: element)
      end

      lines.each do |line|
        add("schema/lines/#{line['key']}.rb",
          template_file: 'schema_line.rb',
          line: line)
      end

      texts.each do |text|
        add("schema/texts/#{text['key']}.rb",
          template_file: 'schema_text.rb',
          text: text)
      end

      add("drawio_shapes.rb"        , template_file: 'drawio_shapes.rb'       , shapes: lookup, shape_length: lookup.length)
      add("dom_builder_shapes.rb"   , template_file: 'dom_builder_shapes.rb'  , shapes: lookup)

      cd(:spec)

      # build spec for each shape
      elements.each do |element|
        add("schema/elements/#{element['key']}_spec.rb",
          template_file: 'schema_element_spec.rb',
          element: element)
      end

      lines.each do |line|
        add("schema/lines/#{line['key']}_spec.rb",
          template_file: 'schema_line_spec.rb',
          line: line)
      end

      texts.each do |text|
        add("schema/texts/#{text['key']}_spec.rb",
          template_file: 'schema_text_spec.rb',
          text: text)
      end

      cd(:app)
      run_command('rubocop -a')

    end
end
