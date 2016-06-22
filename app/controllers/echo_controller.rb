class EchoController < ApplicationController
  respond_to :json

  def create
    echoable = Echoable.new name: model_name, data: model_params

    echoable.session_id = session_header if session_header.present?

    echoable.save!

    render json: echoable, status: 200
  end

  def show
    echoable = default_scope.find params[:id]
    render json: echoable, status: 200
  end

  def index
    echoables = default_scope.all

    render json: echoables
  end

  def destroy
    echoable = default_scope.find params[:id]

    echoable.destroy

    render json: echoable
  end

  def destroy_all
    echoables = default_scope.to_a

    default_scope.delete_all

    render json: echoables
  end

  def update
    echoable = default_scope.find params[:id]

    echoable.attributes = { data: echoable.data.merge(model_params.except(:id)) }

    echoable.save

    render json: echoable, status: 200
  end

  def destroy_session
    if session_header.present?
      Echoable.where(session_id: session_header).destroy_all

      render text: 'SESSION REMOVED', status: 200
    else
      render text: 'NO SESSION FOUND', status: 404
    end
  end

  private

  def default_scope
    scope = Echoable.where(name: model_name)

    if session_header.present?
      scope.where(session_id: session_header)
    else
      scope
    end
  end

  def model_name
    params[:name].try(:singularize)
  end

  def model_params
    model_params = params[model_name] || {}

    model_params.try(:slice, *model_params.try(:keys))
  end

  def session_header
    request.headers['REQUEST_SESSION'] or request.headers['HTTP_REQUEST_SESSION']
  end
end
