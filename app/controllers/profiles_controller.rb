class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @orders = current_user.orders.order(created_at: :desc).limit(5)
  end

  def edit
    @provinces = Province.order(:name)
  end

  def update
    if current_user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully!"
    else
      @provinces = Province.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :address, :city, :postal_code, :province_id)
  end
end