module Spa
  extend ActiveSupport::Concern

  included do
    before_action :set_model
    before_action :set_resource, only: %i[show edit update destroy]

    def index
      collection = @model.all

      render json: Oj.dump(
        collection: collection
      )
    end

    def show
      # @resource = @model.take(params[:id])

      render json: Oj.dump(
        collection: @resource,
        single: true
      )
    end

    def edit
      authorize @resource, :update?
      # raise "not authorized" unless NodePolicy.new(current_app_user, @resource).update?
      render json: Oj.dump(
        collection: @resource,
        single: true
      )
    end

    def update
      authorize @resource, :update?
      if @resource.update(resource_params)
        render json: Oj.dump(
          {
            collection: @resource,
            single: true,
            msg: "#{@model.name} успешно обновлен"
          })
      else
        render json: { errors: @resource.errors, msg: @resource.errors.full_messages.join(', ') }, status: 422
      end
    end

    def destroy
      authorize @resource
      @resource.destroy
      render json: { msg: "#{@model.name} успешно удален" }
    end

    def new
      new_params = begin
                     resource_params
                   rescue
                     {}
                   end
      @resource = @model.new(new_params)
      authorize @resource, :create?

      render json: Oj.dump(collection: @resource)
    end

    def create
      @resource = @model.new resource_params
      authorize @resource

      if @resource.save
        @collection = @model.where(id: @resource.id)

        render json: Oj.dump(collection: @collection)
      else
        render json: { errors: @resource.errors, msg: @resource.errors.full_messages.join(', ') }, status: 422
      end
    end

    private

    def set_resource
      @resource = @model.find_by(id: params[:id])
    end
  end
end
