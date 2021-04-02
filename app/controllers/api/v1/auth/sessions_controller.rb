class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController
  # binding.pry
  skip_before_action :verify_authenticity_token

  private

    def resource_params
      # binding.pry
      params.permit(:name, :email, :password)
    end
end
