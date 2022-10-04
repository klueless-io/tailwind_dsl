KManager.action :utilities_old do
  action do

    # path = '/Users/davidcruwys/dev/kgems/k_templates/templates/tailwind/merakiui'
    # target = :template_merakiui
    # collection_name = :merakiui

    # path = '/Users/davidcruwys/dev/kgems/k_templates/templates/tailwind/devdojo'
    # target = :template_devdojo
    # collection_name = :devdojo

    path = '/Users/davidcruwys/dev/kgems/k_templates/templates/tailwind/tui'
    target = :template_tui
    collection_name = :tui

    # move_files_vue_to_html(path)

    output_file_name = File.join(path, 'all-components.json')
    tailwind = build_folder_file_groups(path)
    tailwind_json = JSON.pretty_generate(tailwind)

    File.write(output_file_name, tailwind_json)

    director = KDirector::Dsls::BasicDsl
      .init(k_builder,
        template_folder: '',
        on_exist:                   :write,                      # %i[skip write compare]
        on_action:                  :execute                     # %i[queue execute]
      )
      .cd(target)

    # BUILDS the HTML FILES
    tailwind[:groups].each do |group|
      next if group[:files].length == 0

      content = group[:files].map { |f| File.read(f[:file]) }.join(separator)
      content = "#{content}\n#{separator}"
      director.add("#{group[:folder]}/all.html", content: page_content(content, group_name: group[:name], collection_name: collection_name))
    end

    director.add('all-component-menu.html', template_file: 'tailwind-collections-menu.html', groups: tailwind[:groups])
    director.add('all-components.txt', groups: tailwind[:groups])

    director.add('all-components.csv', content: group_component_csv(tailwind[:groups]))

    # BUILDS the JSON FILES
    # tailwind[:groups].each do |group|
    #   html = File.read(group[:all_file])

    #   extract_script_regex = /data = ((.|\n)*?)<\/script>/
    #   script_parts = html.scan(extract_script_regex).flatten
    #     .map { |script| script.strip }
    #     .reject { |script| script.empty? }
    #     .map do |script|
    #       begin
    #         # log.warn group[:name]
    #         # log.warn group[:all_file]
    #         JSON.parse(script)
    #       rescue => exception
    #         # puts script
    #         log.error(exception)
    #       end
    #     end


    #   json = {
    #     components: group[:files].map.with_index { |f, index| build_component(f, script_parts[index]) }
    #   }

    #   director.add("#{group[:name]}/all.json", content: JSON.pretty_generate(json))
    # end

    # BUILDS the DSL FILES
    # tailwind[:groups][4..4].each do |group|
    #   puts group[:name]
    #   json_content = File.read(group[:all_file_json])
    #   json = JSON.parse(json_content)

    #   director.add("#{group[:name]}/all.rb", template_file: 'data_shape_dsl.rb', components: massage_components_for_dsl(json['components']))
    #   # puts JSON.pretty_generate(json)
    # end

  end

  def build_component(file_info, data)
    file = file_info[:name]
    component_name = File.basename(file, File.extname(file))
    # content = File.read(file_info[:file])
    {
      component_name: component_name,
      data: data,
    }
  end

  def massage_components_for_dsl(components)
    components
  end


  def move_files_vue_to_html(path)
    glob = File.join(path, '**', '*.vue')

    Dir.glob(glob) do |file|
      if File.file?(file)
        source_file = file
        folder = File.dirname(file)
        new_filename = "#{snake.parse(File.basename(file, File.extname(file)))}.html"
        target_file = File.join(folder, new_filename)
        # puts source_file
        # puts target_file

        FileUtils.mv(source_file, target_file)
      end
    end
  end

  def page_content(content, group_name:, collection_name:)
    <<-HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>#{group_name} | #{collection_name}</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
<p>#{collection_name} > #{group_name} | Go to <a href='../all-component-menu.html'>All Components</a></p>
#{content}
</body>
</html>

    HTML
  end

  def separator
    @separator ||= <<-HTML


<script>
// sample data for this tailwind component
data = {

}
</script>

<hr />

<!-- ------------------------------------------------------ -->

HTML
  end

  def build_folder_file_groups(path)
    glob = File.join(path, '**', '*')

    current_group = {}

    groups = []

    Dir.glob(glob) do |entry|
      if File.directory?(entry)
        relative_folder = Pathname.new(entry).relative_path_from(Pathname.new(path)).to_s
                
        current_group = {
          name: File.basename(entry),
          group_name: File.basename(entry),
          folder: relative_folder, #  entry,
          all_file: File.join(entry, 'all.html'),
          all_file_json: File.join(entry, 'all.json'),
          files: []
        }

        require 'pathname'

        groups << current_group
      elsif entry.end_with?('all.html') || entry.end_with?('all.json') || entry.end_with?('all-component-menu.html') || entry.end_with?('all-components.txt') || entry.end_with?('all-components.json') || entry.end_with?('all-components.csv') || entry.end_with?('.txt')
        # skip
      else
        current_group[:files] << {
          name: File.basename(entry),
          file_name: File.basename(entry),
          file_name_only: File.basename(entry, File.extname(entry)),
          file: entry,
          sample_data_file: File.join(current_group[:folder], File.basename(entry, File.extname(entry)) + '.sample.json')
        }
      end
    end

    groups.each do |group|
      group[:files].sort_by! { |file| file[:name] }
    end
  
    {
      groups: groups
    }
  end

  def titleize
    Cmdlet::Case::Title.new
  end

  def group_component_csv(groups)
    rows = groups.flat_map do |group|
      group[:files].map do |file|
        [group[:name], titleize.call(group[:name]), file[:file_name_only], titleize.call(file[:file_name_only])]
      end
    end
    puts rows

    CSV.generate do |csv|
      csv << ["Group Name", "Group Title", "Component Name", "Component Title"]
      rows.each do |row|
        csv << row
      end
      # System::TableCountQuery.call.to_h.each do |row|
      #   csv << row
      # end
    end
  end
end
KManager.opts.sleep                       = 2
