# frozen_string_literal: true

module TailwindDsl
  module RawComponents
    # The component reader will read the raw component files for each UI Kit.
    class ComponentReader
      attr_reader :name
      attr_reader :path
      attr_reader :component_groups
      attr_reader :current_group
      attr_reader :current_group_key

      class << self
        def build(name, path)
          builder = new
          builder.call(name, path)
          builder.to_h
        end
      end

      def call(name, path)
        @name = name
        @path = path
        @component_groups = {}

        process_files
      end

      def to_h
        groups = component_groups
                 .keys
                 .map { |key| component_groups[key] }
                 .select { |group| group[:files].any? }

        {
          name: name,
          path: path,
          stats: groups.map { |group| { group[:key] => group[:files].size } }.reduce({}, :merge),
          groups: groups
        }
      end

      private

      def process_files
        glob = File.join(path, '**', '*')

        Dir.glob(glob) do |entry|
          next if reject?(entry)

          assign_group(entry)

          process_file(entry) unless File.directory?(entry)
        end
      end

      def create_group(entry, relative_folder, key)
        {
          key: key,
          type: key == '@' ? 'root' : File.basename(entry),
          folder: relative_folder, #  entry,
          sub_keys: key == '@' ? [] : relative_folder.split('/'),
          files: []
        }
      end

      # rubocop:disable Metrics/AbcSize
      def assign_group(entry)
        target_path = File.directory?(entry) ? entry : File.dirname(entry)
        relative_folder = Pathname.new(target_path).relative_path_from(Pathname.new(path)).to_s

        group_key = relative_folder == '.' ? '@' :  relative_folder.split('/').map { |part| snake.call(part) }.join('.')

        @current_group = component_groups[group_key]

        return unless @current_group.nil?

        @current_group = create_group(entry, relative_folder, group_key)
        component_groups[group_key] = @current_group
      end
      # rubocop:enable Metrics/AbcSize

      def process_file(entry)
        key = File.join(current_group[:folder], File.basename(entry, File.extname(entry)))
        current_group[:files] << {
          name: File.basename(entry),
          file_name: File.basename(entry),
          file_name_only: File.basename(entry, File.extname(entry)),
          absolute_file: entry,
          file: File.join(current_group[:folder], File.basename(entry)),
          target: {
            html_file: "#{key}.html",
            clean_html_file: "#{key}.clean.html",
            tailwind_config_file: "#{key}.tailwind.config.js",
            settings_file: "#{key}.settings.json",
            data_file: "#{key}.data.json",
            astro_file: "#{key}.astro"
          }
        }
      end

      def reject?(entry)
        entry.end_with?('all.html') ||
          entry.end_with?('all.json') ||
          entry.end_with?('all-component-menu.html') ||
          entry.end_with?('all-components.txt') ||
          entry.end_with?('all-components.json') ||
          entry.end_with?('all-components.csv') ||
          entry.end_with?('.txt')
      end

      def snake
        Cmdlet::Case::Snake.new
      end
    end
  end
end
