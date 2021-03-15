class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  skip_before_action :verify_authenticity_token

  private

    def sign_up_params
      params.permit(:name, :email, :password)
    end
end
