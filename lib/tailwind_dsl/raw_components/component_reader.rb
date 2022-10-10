# frozen_string_literal: true

module TailwindDsl
  module RawComponents
    # The component reader will read the raw component files for each UI Kit.
    class ComponentReader
      attr_reader :design_system

      attr_reader :group_lookup
      attr_reader :current_group

      class << self
        def build(name, path)
          builder = new
          builder.call(name, path)
          builder.to_h
        end
      end

      def call(name, path)
        @design_system = ::TailwindDsl::Transformers::RawComponents::DesignSystem.new(
          name: name,
          path: path
        )

        @group_lookup = {}

        process_files

        groups = group_lookup
                 .keys
                 .map { |key| group_lookup[key] }
                 .select { |group| group[:files].any? }

        groups.each do |group|
          design_system.add_group(group)
        end
      end

      def to_h
        design_system.to_h
      end

      # def to_h
      #   groups = group_lookup
      #            .keys
      #            .map { |key| group_lookup[key] }
      #            .select { |group| group[:files].any? }

      #   {
      #     name: name,
      #     path: path,
      #     stats: groups.map { |group| { group[:key] => group[:files].size } }.reduce({}, :merge),
      #     groups: groups
      #   }
      # end

      private

      def process_files
        glob = File.join(design_system.path, '**', '*')

        Dir.glob(glob) do |entry|
          next if reject?(entry)

          assign_group(entry)

          process_file(entry) unless File.directory?(entry)
        end
      end

      # rubocop:disable Metrics/AbcSize
      def assign_group(entry)
        target_path = File.directory?(entry) ? entry : File.dirname(entry)
        relative_folder = Pathname.new(target_path).relative_path_from(Pathname.new(design_system.path)).to_s

        group_key = relative_folder == '.' ? '@' :  relative_folder.split('/').map { |part| snake.call(part) }.join('.')

        @current_group = group_lookup[group_key]


        return unless current_group.nil?

        @current_group = group(entry, relative_folder, group_key)
        group_lookup[group_key] = current_group

      end
      # rubocop:enable Metrics/AbcSize

      def process_file(entry)

        key = File.join(current_group[:folder], File.basename(entry, File.extname(entry)))
        target = target_file(key)
        source = source_file(entry, current_group[:folder], target)
        # current_group[:files] << source # source_file(entry, current_group[:folder], key)
        current_group.add_file(source)
      end

      def group(entry, relative_folder, key)
        ::TailwindDsl::Transformers::RawComponents::Group.new(
          key: key,
          type: key == '@' ? 'root' : File.basename(entry),
          folder: relative_folder, #  entry,
          sub_keys: key == '@' ? [] : relative_folder.split('/')
        )
      end

      def source_file(entry, folder, target)
        ::TailwindDsl::Transformers::RawComponents::SourceFile.new(
          name: File.basename(entry),
          file_name: File.basename(entry),
          file_name_only: File.basename(entry, File.extname(entry)),
          absolute_file: entry,
          file: File.join(folder, File.basename(entry)),
          target: target
        )
      end

      def target_file(key)
        ::TailwindDsl::Transformers::RawComponents::TargetFile.new(
          html_file: "#{key}.html",
          clean_html_file: "#{key}.clean.html",
          tailwind_config_file: "#{key}.tailwind.config.js",
          settings_file: "#{key}.settings.json",
          data_file: "#{key}.data.json",
          astro_file: "#{key}.astro"
        )
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
