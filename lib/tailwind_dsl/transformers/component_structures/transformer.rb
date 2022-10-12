# frozen_string_literal: true

module TailwindDsl
  module Transformers
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
      class Transformer
        COMMENT_REGEX = /<!--[\s\S]*?-->/.freeze
        BLANK_LINE_REGEX = /(\n\s*\n)+/.freeze
        TAILWIND_CONFIG_REGEX = /```(?<tailwind>\n[\s\S]+?)```/.freeze

        # .gsub(/(\n\s*\n)+/, "\n")
        attr_reader :graph
        attr_reader :root_target_path
        attr_reader :reset_root_path

        def initialize(graph, root_target_path, reset_root_path: false)
          @graph = graph
          @root_target_path = root_target_path
          @reset_root_path = reset_root_path
        end

        def generate
          assert_root_target_path_exists

          delete_target_root_path if reset_root_path

          graph.design_systems.each do |name, design_system|
            process_design_system(name, design_system)
          end
        end

        private

        def assert_root_target_path_exists
          raise 'Target path does not exist' unless Dir.exist?(root_target_path)
        end

        def delete_target_root_path
          FileUtils.rm_rf(Dir.glob("#{root_target_path}/*"))
        end

        def process_design_system(design_system_name, design_system)
          design_system[:groups].each do |group|
            process_group(design_system_name, group)
          end
        end

        def process_group(design_system_name, group)
          group[:files].each do |file|
            # puts "DSN: #{design_system_name}, GRP: #{group[:type]}, FILE: #{file[:file]}"
            data = Data.new(design_system_name, group, file)

            unless data.source.exist?
              puts "Source file does not exist: #{data.source.file}"
              next
            end

            process_component(data)
          end
        end

        def process_component(data)
          # Create a folder for the component
          make_target_folder(data)

          # Create a HTML file for each component
          create_html_file(data)

          # Create a clean HTML file for each component (comments removed)
          create_clean_html_file(data)

          # Create a tailwind config file (if one exists) - look in first comment for the ``` ```
          create_tailwind_config_file(data)

          # Create a settings file after extracting information from the HTML file
          create_settings_file(data)

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

        def target_path(data)
          File.join(root_target_path, data.design_system_name, data.target.folder)
        end

        def target_file(data, file)
          File.join(root_target_path, data.design_system_name, file)
        end

        def make_target_folder(data)
          FileUtils.mkdir_p(target_path(data))
        end

        def create_html_file(data)
          # rules:
          # if the html file exists, then read the settings file, if the settings has html overwrite, then overwrite the html file
          # overwrite = true
          FileUtils.cp_r(data.source.file, target_file(data, data.target.html_file), remove_destination: true) # if overwrite
        end

        def create_clean_html_file(data)
          html = data.source.content || ''
          data.captured_comment_list = html.scan(COMMENT_REGEX)
          data.captured_comment_text = data.captured_comment_list.join("\n")

          html = html.gsub(COMMENT_REGEX, '').gsub(BLANK_LINE_REGEX, "\n").lstrip

          File.write(target_file(data, data.target.clean_html_file), html)
        end

        def create_tailwind_config_file(data)
          data.captured_tailwind_config = extract_tailwind_config(data)

          File.write(target_file(data, data.target.tailwind_config_file), data.captured_tailwind_config) if data.captured_tailwind_config
        end

        def create_settings_file(data)
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
            source: extract_source(data),
            custom_html: {
              html: data.captured_comment_text.match(/<html.*>/),
              body: data.captured_comment_text.match(/<body.*>/)
            },
            tailwind_config: tailwind_config_settings(data.captured_tailwind_config)
          }

          File.write(target_file(data, data.target.settings_file), JSON.pretty_generate(settings))
        end

        def extract_tailwind_config(data)
          return nil if data.captured_comment_list.length.zero? || !data.captured_comment_list.first.include?('// tailwind.config.js')

          data.captured_comment_list.first.match(TAILWIND_CONFIG_REGEX)[:tailwind]
        end

        def extract_source(data)
          # In future I may be able to store the source in a comment in the HTML file
          # but at the moment all components are generally from TailwindUI and the source
          # URL can be inferred from the sub keys.

          return "https://tailwindui.com/components/#{data.group.sub_keys.join('/')}" if data.design_system_name == 'tui'

          "##{data.design_system_name}/#{data.group.sub_keys.join('/')}"
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
