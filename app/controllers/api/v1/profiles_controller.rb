class Api::V1::ProfilesController < ApplicationController
  skip_authorization_check
  before_action :doorkeeper_authorize!, only: [:me, :index]

  respond_to :json

  def me
    respond_with(current_resource_owner)
  end

  def index
    @users = User.where.not(id:current_resource_owner)
    respond_with(@users)
  end

  protected
  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end