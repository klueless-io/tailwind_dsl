KManager.action :project_plan do
  action do

    DrawioDsl::Drawio
      .init(k_builder, on_exist: :write, on_action: :execute)
      .diagram(rounded: 1, glass: 1)
      .page('In progress', theme: :style_03, margin_left: 0, margin_top: 0) do

        h5(x: 300, y: 0, w: 400, h: 80, title: 'DrawIO DSL')

        grid_layout(y: 90, direction: :horizontal, grid_h: 80, grid_w: 320, wrap_at: 3, grid: 0)

        # Goals for Tailwind DSL
        #   Should be able to ask for a component by type and name and get back a data structure
        #   *Data structure should have the template HTML plus other meta data such as front matter
        #   Should be able to construct a page with sequential list of components
        #   Any component should support nested components
        #   Any component should support a data structure
        #   Should be able to construct a website with a bunch of pages
        #   Should be able to construct navigation structures that can provide data into components

        todo(title: 'use a domain model generator to build base classes and unit tests')
        todo(title: 'restart the application so that I can figure out the issues with RuboCop')
        todo(title: 'build a sample DSL to test how this can be used')

      end
      .page('To Do', theme: :style_02, margin_left: 0, margin_top: 0) do

        # h5(x: 300, y: 0, w: 400, h: 80, title: 'DrawIO DSL')

        grid_layout(y:90, direction: :horizontal, grid_h: 80, grid_w: 320, wrap_at: 3, grid: 0)

      end
      .page('Done', theme: :style_06, margin_left: 0, margin_top: 0) do

        # h5(x: 300, y: 0, w: 400, h: 80, title: 'DrawIO DSL')

        grid_layout(y:90, direction: :horizontal, grid_h: 80, grid_w: 320, wrap_at: 3, grid: 0)

        todo(title: 'build file reader for raw design system files')
        todo(title: 'use the design system file reader to generate a component graph in ./builder/utilities.rb')

      end
      .cd(:docs)
      .save('project-plan/project.drawio')
      .export_svg('project-plan/project_in_progress', page: 1)
      .export_svg('project-plan/project_todo'       , page: 2)
      .export_svg('project-plan/project_done'       , page: 3)
  end
end
