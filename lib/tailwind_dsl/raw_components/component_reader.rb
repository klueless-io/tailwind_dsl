# frozen_string_literal: true

module TailwindDsl
  module RawComponents
    # the component reader will read the component files for a UI Kit.
    class ComponentReader
      attr_reader :name
      attr_reader :path
      attr_reader :component_groups
      attr_reader :current_group
      attr_reader :current_group_key

      class << self
        def build(name, path)
          builder = new
          builder.process(name, path)
          builder.to_h
        end
      end

      def process(name, path)
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

          if File.directory?(entry)
            set_group(entry)
          else
            set_group(entry)
            process_file(entry)
          end
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

      def set_group(entry)
        target_path = File.directory?(entry) ? entry : File.dirname(entry)
        relative_folder = Pathname.new(target_path).relative_path_from(Pathname.new(path)).to_s

        group_key = relative_folder == '.' ? "@" :  relative_folder.split('/').map { |part| snake.call(part) }.join('.')

        @current_group = component_groups[group_key]

        return unless @current_group.nil?
        
        @current_group = create_group(entry, relative_folder, group_key)
        component_groups[group_key] = @current_group
      end

      def process_file(entry)
        current_group[:files] << {
          name: File.basename(entry),
          file_name: File.basename(entry),
          file_name_only: File.basename(entry, File.extname(entry)),
          absolute_file: entry,
          file: File.join(current_group[:folder], File.basename(entry)),
          sample_data_file: File.join(current_group[:folder], File.basename(entry, File.extname(entry)) + '.sample.json')
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