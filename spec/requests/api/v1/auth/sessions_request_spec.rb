require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "Userのログイン POST/sign_in" do
    subject { post(api_v1_user_session_path, params: params, headers: headers) }

    ########## 正常系 ###########
    context "request.bodyに適切なパラメーターが入っている場合" do
      let(:current_user) { create(:user) }
      let(:params) { { name: current_user.name, email: current_user.email, password: current_user.password } }

      it "ログインできる" do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.headers["access-token"]).not_to be_nil
        expect(response.headers["token-type"]).not_to be_nil
        expect(response.headers["client"]).not_to be_nil
        expect(response.headers["expiry"]).not_to be_nil
        expect(response.headers["uid"]).not_to be_nil
      end
    end

    ########## 異常系 ###########

    context "request.bodyのパラメーター(email)が不適切な場合" do
      let(:current_user) { create(:user) }
      let(:params) { { email: "", password: current_user.password } }
      it "ログインできない" do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(response.headers["access-token"]).to be_nil
        expect(response.headers["token-type"]).to be_nil
        expect(response.headers["client"]).to be_nil
        expect(response.headers["expiry"]).to be_nil
        expect(response.headers["uid"]).to be_nil
      end
    end

    context "request.bodyのパラメーター(password)が不適切な場合" do
      let(:current_user) { create(:user) }
      let(:params) { { email: current_user.email, password: "" } }
      it "ログインできない" do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(response.headers["access-token"]).to be_nil
        expect(response.headers["token-type"]).to be_nil
        expect(response.headers["client"]).to be_nil
        expect(response.headers["expiry"]).to be_nil
        expect(response.headers["uid"]).to be_nil
      end
    end
  end

  fdescribe "Userのログアウト DELETE/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }
    context "適切なrequest.headersが送信できている" do
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }
      it "ログアウトできる" do
        # binding.pry
        subject
        binding.pry
        expect(response).to have_http_status(200)
        expect(response.headers).not_to include(:headers)
      end
    end
  end
end
