require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  fdescribe "Userのログイン POST/sign_in" do
    subject { post(api_v1_user_session_path, params: params, headers: headers) }

    ########## 正常系 ###########
    context "request.bodyに適切なパラメーターが入っている場合" do
      let(:current_user) { create(:user) }
      let(:params) { { name: current_user.name , email: current_user.email, password: current_user.password } }

      it "ログインできる" do
        subject
        # binding.pry
        expect(response).to have_http_status(200)
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
        # binding.pry
        expect(response).to have_http_status(401)
        expect(response.headers["access-token"]).to be_nil
        expect(response.headers["token-type"]).to be_nil
        expect(response.headers["client"]).to be_nil
        expect(response.headers["expiry"]).to be_nil
        expect(response.headers["uid"]).to be_nil
      end
    end

    context "request.bodyのパラメーター(password)が不適切な場合" do
      let(:current_user) { create(:user) }
      let(:params) { { email: current_user.email, password: ""} }
      it "ログインできない" do
        subject
        # binding.pry
        expect(response).to have_http_status(401)
        expect(response.headers["access-token"]).to be_nil
        expect(response.headers["token-type"]).to be_nil
        expect(response.headers["client"]).to be_nil
        expect(response.headers["expiry"]).to be_nil
        expect(response.headers["uid"]).to be_nil
      end
    end



    ############ 正常系 ############
    ############ ここは後でするべきところ ##############
    # context 'context: general authentication via API, ' do
    #   let(:client) { create(:user) }
    #   let(:current_user) { create(:user) }
    #   let(:params) { { name: current_user.name, email: current_user.email, password: current_user.password } }
    #   let(:headers) { current_user.create_new_auth_token }
    #   it "ログインできなければ他の機能は使えません" do
    #     binding.pry
    #     get api_client_path()
    #     ## statusがエラーをはく
    #     expect(response.status).to eq(401)
    #   end
    # end

    ######## これはsessionのテストでは不要な機能でした #############
    # context "request.headerに指定した4つの値が入っている場合" do
    #   # let(:client) { create(:user) }
    #   let(:current_user) { create(:user) }
    #   let(:headers) { current_user.create_new_auth_token }
    #   let(:params) { { name: current_user.name, email: current_user.email, password: current_user.password } }

    #   it "response.bodyの読み込みに進む" do
    #     binding.pry
    #     subject
    #     binding.pry
    #     res = JSON.parse(response.body)
    #     expect(response.headers["uid"]).to be_present
    #     expect(response.headers["access-token"]).to be_present
    #     expect(response.headers["client"]).to be_present
    #     expect(response.headers["expiry"]).to be_present
    #     expect(response).to have_http_status(:ok)
    #   end
    # end
    # context "response.bodyに適切なパラメーターが入力できている場合" do
    #   let(:current_user) { create(:user) }
    #   let(:params) { { name: current_user.name, email: current_user.email, password: current_user.password } }
    #   let(:headers) { current_user.create_new_auth_token }
    #   it "ログインできる" do
    #     binding.pry
    #     subject
    #     binding.pry
    #     res = JSON.parse(response.body)
    #     expect(res["data"]["name"]).to eq params[:name]
    #     expect(res["data"]["email"]).to eq params[:email]
    #     expect(current_user.password).to eq params[:password]
    #     expect(response).to have_http_status(:ok)
    #   end
    # end

    #     ############ 異常系 ############
    # context "request.header & body に適切な値が入力されていない場合" do
    # end
    # fcontext "request.headerのパラメーターが空の場合" do
    #   let(:current_user) { create(:user) }
    #   let(:params) { { name: current_user.name, email: current_user.email, password: current_user.password } }
    #   let(:headers) do
    #     { "access-token": nil, "token-type": nil, "client": nil, "expiry": nil, "uid": nil }
    #   end
    #   it "ログインできない" do

    #     binding.pry
    #     subject
    #     binding.pry
    #     res = JSON.parse(response.body)
    #     expect(request.headers["access-token"]).to be_nil
    #     expect(request.headers["token-type"]).to be_nil
    #     expect(request.headers["client"]).to be_nil
    #     expect(request.headers["expiry"]).to be_nil
    #     expect(request.headers["uid"]).to be_nil
    #     binding.pry
    #     expect(response).to have_http_status(401)
    #   end
    # end
    # context "response.bodyのパラメーターが空の場合" do
    #   let(:current_user) { create(:user) }
    #   let(:params) { { name: nil, email: current_user.email, password: current_user.password } }
    #   let(:headers) { current_user.create_new_auth_token }
    #   it "ログインできない" do
    #     subject
    #     res = JSON.parse(response.body)

    #     expect(User.where(name: "")).to eq params[:name]
    #     # expect(response).to have_http_status(:401)
    #   end
    #   it "ログインできない" do
    #     # expect(params[:password]).to eq nil
    #     # expect(response).to have_http_status(:401)
    #   end
    #   # it "ログインできない" do
    #   #   expect(response.headers["expiry"]).to be_blank
    #   #   # expect(response).to have_http_status(:401)
    #   # end
    # end

  end
end
