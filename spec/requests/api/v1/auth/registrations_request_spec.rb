require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "Userの登録 POST/registrations" do
    # 主題 = subject(subjectをベースとしたテストを作ってみよう！ってヤツ)
    ############################### 正常系テスト ###############################
    subject { post(api_v1_user_registration_path, params: params) }

    context "リクエストが通っている場合" do
      let(:params) { attributes_for(:user) }

      it "ユーザーが登録される" do
        expect { subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(:ok)
      end
    end
    ###### 真のゴールがなんなのかを考える！！！ ######
    ###### この度はheaderが通っているのかどうかをテストしていなかった ######

    context "headerをキチンと受け取れる" do
      let(:params) { attributes_for(:user) }
      it "header情報を取得することができる" do
        subject
        header = response.header
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["expiry"]).to be_present
        expect(header["uid"]).to be_present
        expect(header["token-type"]).to be_present
      end
    end

    context "Name/Emailが入力されている" do
      let(:params) { attributes_for(:user) }
      it "登録ができる" do
        subject
        res = JSON.parse(response.body)
        expect(res["data"]["name"]).to eq params[:name]
        expect(response).to have_http_status(:ok)
      end

      it "名前が登録される" do
        subject
        res = JSON.parse(response.body)
        expect(res["data"]["email"]).to eq params[:email]
        expect(response).to have_http_status(:ok)
      end
    end

    ############################### 異常系テスト ###############################

    context "適切な名前が入力されていない" do
      let(:params) { attributes_for(:user, name: nil) }
      it "新規登録ができない" do
        subject

        res = JSON.parse(response.body)
        expect(res["data"]["name"]).to eq params[:name]
        expect(response).to have_http_status(:unprocessable_entity)
        expect(res["errors"]["name"]).to include "can't be blank"
      end
    end

    context "適切なメールアドレスが入力されていない" do
      let(:params) { attributes_for(:user, email: nil) }
      it "新規登録ができない" do
        subject
        res = JSON.parse(response.body)

        expect(res["data"]["email"]).to eq params[:email]
        expect(response).to have_http_status(:unprocessable_entity)
        expect(res["errors"]["email"]).to include "can't be blank"
      end
    end

    context "適切なpasswordが入力されていない" do
      let(:params) { attributes_for(:user, password: nil) }
      it "新規登録ができない" do
        subject
        res = JSON.parse(response.body)

        expect(res["data"]["password"]).to eq params[:password]
        expect(response).to have_http_status(:unprocessable_entity)
        expect(res["errors"]["password"]).to include "can't be blank"
      end
    end
  end

  describe "Userのログイン POST/sign_in" do
    ############### どうしてもrequest.headerに値を入れたい/入れないとrequest.body(name,email,password)の入力までに至らない ################3
    subject { post(api_v1_user_session_path, params: params, headers: headers) }


    ############ 正常系 ############
    fcontext 'context: general authentication via API, ' do
      let(:params) { attributes_for(:user) }
      it "doesn't give you anything if you don't log in" do
        binding.pry
        get api_client_path()
        expect(response.status).to eq(401)
      end
    end



    context "request.headerに指定した4つの値が入っている場合" do
      let(:params) { attributes_for(:user) }
      # let(:params) { { name: current_user.name, email: current_user.email, password: current_user.password } }
      # let(:headers) { create_new_auth_token }
      let(:headers) { request.headers.merge! resource.create_new_auth_token }

      it "response.bodyの読み込みに進む" do
        binding.pry
        subject
        res = JSON.parse(response.body)
        expect(response.headers["uid"]).to be_present
        expect(response.headers["access-token"]).to be_present
        expect(response.headers["client"]).to be_present
        expect(response.headers["expiry"]).to be_present

        expect(response).to have_http_status(:ok)
      end
    end
    context "response.bodyに適切なパラメーターが入力できている場合" do
      let(:current_user) { create(:user) }
      let(:params) { { name: current_user.name, email: current_user.email, password: current_user.password } }
      let(:headers) { current_user.create_new_auth_token }
      it "ログインできる" do
        subject
        res = JSON.parse(response.body)
        expect(res["data"]["name"]).to eq params[:name]
        expect(res["data"]["email"]).to eq params[:email]
        expect(current_user.password).to eq params[:password]
        expect(response).to have_http_status(:ok)
      end
    end
        ######## ↑通りました 次は↓のcodeからです！ #############
        ############ 異常系 ############
    context "request.header & body に適切な値が入力されていない場合" do
    end
    context "response.headerのパラメーターが空の場合" do
      let(:current_user) { create(:user) }
      let(:params) { { name: current_user.name, email: current_user.email, password: current_user.password } }
      let(:headers) { { "access-token": nil,"token-type": nil, "client": nil,"expiry": nil,"uid": nil } }
      it "ログインできない" do
        binding.pry
        subject
        binding.pry
        res = JSON.parse(response.body)
        expect(response.headers).not_to include(:"access-token")
        expect(response.headers).not_to include(:"token-type")
        expect(response.headers).not_to include(:"client")
        expect(response.headers).not_to include(:"expiry")
        expect(response.headers).not_to include(:"uid")
        expect(response).to have_http_status(401)
      end
    end
    context "response.bodyのパラメーターが空の場合" do
      let(:current_user) { create(:user) }
      let(:params) { { name: nil, email: current_user.email, password: current_user.password } }
      let(:headers) { current_user.create_new_auth_token }
      it "ログインできない" do
        subject
        res = JSON.parse(response.body)

        expect(User.where(name: "")).to eq params[:name]
        # expect(response).to have_http_status(:401)
      end
      it "ログインできない" do
        # expect(params[:password]).to eq nil
        # expect(response).to have_http_status(:401)
      end
      # it "ログインできない" do
      #   expect(response.headers["expiry"]).to be_blank
      #   # expect(response).to have_http_status(:401)
      # end
    end

  end
end
