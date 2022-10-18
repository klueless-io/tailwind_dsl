# frozen_string_literal: true

module TailwindDsl
  module Etl
    module ComponentStructures
      # Generate component structures such as HTML, Astro, and data shapes, settings, tailwind config as
      # individual files from the raw component data.
      #
      # By default this will just refresh the files on the system, in future it might have some smarts around
      # what to update, but for now it is all files.
      #
      # Some times you need to reset the data, ie. delete the contents of the target folder, this happens when
      # you change the structure of the source input files. This is a destructive operation, so be warned.
      #
      # To execute this you need to pass reset_root_path: true
      class Generator
        COMMENT_REGEX = /<!--[\s\S]*?-->/.freeze
        BLANK_LINE_REGEX = /(\n\s*\n)+/.freeze
        TAILWIND_CONFIG_REGEX = /```(?<tailwind>\n[\s\S]+?)```/.freeze

        # .gsub(/(\n\s*\n)+/, "\n")
        attr_reader :uikit
        attr_reader :components
        # Location for raw components
        attr_reader :source_root_path
        # Location for component structures
        attr_reader :target_root_path
        attr_reader :reset_root_path

        def initialize(uikit, source_root_path, target_root_path, reset_root_path: false)
          @uikit = uikit
          @source_root_path = source_root_path
          @target_root_path = target_root_path
          @reset_root_path = reset_root_path
        end

        def generate
          assert_target_root_path_exists

          delete_target_root_path if reset_root_path

          @components = query_components

          process_components
        end

        private

        def assert_target_root_path_exists
          raise 'Target path does not exist' unless Dir.exist?(target_root_path)
        end

        def delete_target_root_path
          FileUtils.rm_rf(Dir.glob("#{target_root_path}/*"))
        end

        def query_components
          RawComponentQuery.query(uikit,
                                  source_root_path: source_root_path,
                                  target_root_path: target_root_path).records
        end

        def process_components
          @components.each do |component|
            unless File.exist?(component.absolute_path.source_file)
              puts "Source file does not exist: #{component.absolute_path.source_file}"
              next
            end

            # puts "DSN: #{component.design_system.name}, GRP: #{component.group.type}, FILE: #{component.relative_path.source_file}"

            process_component(component)
          end
        end

        def process_component(component)
          # Create a folder for the component
          make_target_folder(component)

          # # Create a HTML file for each component
          create_html_file(component)

          # # Create a clean HTML file for each component (comments removed)
          create_clean_html_file(component)

          # # Create a tailwind config file (if one exists) - look in first comment for the ``` ```
          create_tailwind_config_file(component)

          # # Create a settings file after extracting information from the HTML file
          create_settings_file(component)

          # Build a menu of sources
          # see: https://tailwindui.com/components/application-ui/data-display/description-lists

          # Create a data file

          # Create an Astro file
          # Create an HTML file
          # Create a HTML file without tailwind config comment, but keep (DATA ONLY) comments
        end

        # Write a settings file
        #   Record the source of the component
        # Write a data file
        #   Note that the data file is meant to represent the data in the raw component
        # Write an Astro file

        def target_path(component)
          File.join(target_root_path, component.design_system.name, component.group.folder)
        end

        def make_target_folder(component)
          FileUtils.mkdir_p(target_path(component))
        end

        def create_html_file(component)
          # rules:
          # if the html file exists, then read the settings file, if the settings has html overwrite, then overwrite the html file
          # overwrite = true
          FileUtils.cp_r(component.absolute_path.source_file, component.absolute_path.target_html_file, remove_destination: true) # if overwrite
        end

        def create_clean_html_file(component)
          html = File.read(component.absolute_path.source_file) || ''
          component.captured_comment_list = html.scan(COMMENT_REGEX)
          component.captured_comment_text = component.captured_comment_list.join("\n")

          html = html.gsub(COMMENT_REGEX, '').gsub(BLANK_LINE_REGEX, "\n").lstrip

          File.write(component.absolute_path.target_clean_html_file, html)
        end

        def create_tailwind_config_file(component)
          component.captured_tailwind_config = extract_tailwind_config(component)

          File.write(component.absolute_path.target_tailwind_config_file, component.captured_tailwind_config) if component.captured_tailwind_config
        end

        def create_settings_file(component)
          # CUSTOM
          # templates/tailwind/tui/ecommerce/page/product-pages/02.html
          # templates/tailwind/tui/ecommerce/components/product-overviews/04.html
          # templates/tailwind/tui/marketing/page/pricing/01.html
          # templates/tailwind/tui/marketing/page/pricing/04.html
          # templates/tailwind/tui/marketing/page/pricing/05.html
          # templates/tailwind/tui/marketing/page/contact/01.html
          # templates/tailwind/tui/marketing/page/contact/04.html
          # templates/tailwind/tui/marketing/page/contact/02.html
          # templates/tailwind/tui/marketing/page/contact/03.html
          # templates/tailwind/tui/marketing/page/landing/02.html
          # templates/tailwind/tui/marketing/page/landing/03.html
          # templates/tailwind/tui/application-ui/page/settings-screens/01.html
          # templates/tailwind/tui/application-ui/page/settings-screens/04.html
          # templates/tailwind/tui/application-ui/page/settings-screens/05.html
          # templates/tailwind/tui/application-ui/page/settings-screens/02.html
          # templates/tailwind/tui/application-ui/page/detail-screens/04.html
          # templates/tailwind/tui/application-ui/page/detail-screens/03.html
          # templates/tailwind/tui/application-ui/page/detail-screens/03.html
          # templates/tailwind/tui/application-ui/page/home-screens/04.html
          # templates/tailwind/tui/application-ui/page/home-screens/05.html
          # templates/tailwind/tui/application-ui/page/home-screens/02.html
          # templates/tailwind/tui/application-ui/component/list/feed/03.html
          settings = {
            source: extract_source(component),
            custom_html: {
              html: component.captured_comment_text.match(/<html.*>/),
              body: component.captured_comment_text.match(/<body.*>/)
            },
            tailwind_config: tailwind_config_settings(component.captured_tailwind_config)
          }

          File.write(component.absolute_path.target_settings_file, JSON.pretty_generate(settings))
        end

        def extract_tailwind_config(component)
          return nil if component.captured_comment_list.length.zero? || !component.captured_comment_list.first.include?('// tailwind.config.js')

          component.captured_comment_list.first.match(TAILWIND_CONFIG_REGEX)[:tailwind]
        end

        def extract_source(component)
          # In future I may be able to store the source in a comment in the HTML file
          # but at the moment all components are generally from TailwindUI and the source
          # URL can be inferred from the sub keys.

          return "https://tailwindui.com/components/#{component.group.sub_keys.join('/')}" if component.design_system.name == 'tui'

          "##{component.design_system.name}/#{component.group.sub_keys.join('/')}"
        end

        def tailwind_config_settings(raw_tailwind_config)
          return {} unless raw_tailwind_config

          {
            plugins: {
              forms: raw_tailwind_config.include?("require('@tailwindcss/forms')"),
              aspect_ratio: raw_tailwind_config.include?("require('@tailwindcss/aspect-ratio')"),
              line_clamp: raw_tailwind_config.include?("require('@tailwindcss/line-clamp')"),
              typography: raw_tailwind_config.include?("require('@tailwindcss/typography')")
            }
          }
        end
      end
    end
  end
end
