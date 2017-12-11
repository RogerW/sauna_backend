class UsersContactsController < ApplicationController
  before_action :set_users_contact, only: [:show, :update, :destroy]

  # GET /users_contacts
  def index
    @users_contacts = UsersContact.all

    render json: @users_contacts
  end

  # GET /users_contacts/1
  def show
    render json: @users_contact
  end

  # POST /users_contacts
  def create
    @users_contact = UsersContact.new(users_contact_params)

    if @users_contact.save
      render json: @users_contact, status: :created, location: @users_contact
    else
      render json: @users_contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users_contacts/1
  def update
    if @users_contact.update(users_contact_params)
      render json: @users_contact
    else
      render json: @users_contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users_contacts/1
  def destroy
    @users_contact.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_users_contact
      @users_contact = UsersContact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def users_contact_params
      params.require(:users_contact).permit(:user_id, :contact_id)
    end
end
