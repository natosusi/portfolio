require 'rails_helper'

RSpec.describe User, type: :model do
  #モデルのテストデータを準備
  let(:user) {build(:user)}

  #テスト対象
  describe "name、email、passwordのバリデーション" do
    #期待値
    it "name、email、passwordのバリデーションが通ること" do
      expect(user).to be_valid
    end
  end

  describe "nameのバリデーション" do
    it "nameが空の場合はバリデーションする。" do
      user.name = ""
      expect(user).to_not be_valid
    end
  end

  describe "emailのバリデーション" do
    context "一意性制約の確認" do
      before do
        @user = build(:user)
      end
      it "同じemailの場合エラーメッセージが返される" do
        @user.save
        another_user = build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include("メールアドレスはすでに存在します")
      end
    end

    it "emailが空の場合はバリデーションする。" do
      user.email = ""
      expect(user).to_not be_valid
    end
  end

  describe "passwordのバリデーション" do 
    it "passwordが空の場合はバリデーションする。" do
      user.password = ""
      expect(user).to_not be_valid
    end
    
    it "passwordが6文字以下の場合はバリデーションする。" do
      user.password = "hoge"
      expect(user).to_not be_valid
    end
  end

end
