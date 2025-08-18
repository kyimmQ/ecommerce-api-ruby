class Buyer::ProfileController < Buyer::ApplicationController
  def show
    @user = current_buyer
  end

  def edit
    @user = current_buyer
  end

  def update
    @user = current_buyer

    if @user.update(user_params)
      redirect_to buyer_profile_path, notice: "Profile updated successfully!"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone, :address)
  end
end
