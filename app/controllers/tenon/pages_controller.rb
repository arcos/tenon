module Tenon
  class PagesController < Tenon::ResourcesController
    before_filter :get_potential_parents, only: [:new, :edit, :update, :create]

    def index
      respond_to do |format|
        format.html
        format.json do
          if params[:q].blank?
            @pages = Tenon::Page.order(:lft)
          else
            pages = Tenon::Page.where(search_args).map { |p| [p.ancestors, p] }
            @pages = pages.flatten.uniq.sort_by(&:lft)
          end
        end
      end
    end

    def new
      resource.parent_id = params[:parent_id]
      super
    end

    def edit
      load_version if params[:version]
      super
    end

    def reorder
      @pages = Tenon::Page.reorder!(params[:item_list], params[:parent_id])
      render nothing: true
    end

    private

    def get_potential_parents
      id = params[:id] || 0
      @potential_parents = Tenon::Page.order(:lft).decorate
    end

    def resource_params
      params.require(:page).permit!
    end

    def load_version
      resource.has_history_includes.each do |assoc_name|
        assoc = resource.send(assoc_name)
        if assoc.respond_to?(:each)
          assoc.each(&:mark_for_destruction)
        else
          assoc.mark_for_destruction
        end
      end

      version = ItemVersion.find(params[:version])
      attrs = ActionController::Parameters.new(Marshal.load(version.attrs))
      resource.assign_attributes(attrs.permit!)
      flash.now[:notice] = 'You are viewing a draft version of this resource.  Hitting save will replace the active version with this version.'
    end
  end
end
