# monkey patch active scaffold to remove some of the gratuitous ajax
module ActiveScaffold

  module ClassMethods
   alias_method :orig_active_scaffold, :active_scaffold

    def active_scaffold(model_id = nil, ajax = false, &block)
      orig_active_scaffold(model_id, &block)

     config = active_scaffold_config
      config.create.link.page = !ajax if config.actions.include?(:create)
      config.show.link.page = !ajax if config.actions.include?(:show)
      config.update.link.page = !ajax if config.actions.include?(:update)
    end
  end

  module Helpers

    module FormColumns

      # Patches a bug where current AS with Rails 2.0.1 file_exists? in
      # ActionView::Base will return 'rjs' from the extension of @first_render
      # variable containing 'edit_associated.rjs' and thus will try to render
      # out a non-existent partial.
      def override_form_field_partial?(column)
        path, partial_name = partial_pieces(override_form_field_partial(column))
        file = file_exists? File.join(path, "_#{partial_name}")
        (file == 'rjs') ? false : file
      end

    end

  end

end

