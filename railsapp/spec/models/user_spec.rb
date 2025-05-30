require 'rails_helper'

RSpec.describe User, type: :model do
  #モデルのテストデータを準備
  let(:user) {build(:user)}

  describe "バリデーションのテスト" do
    #テスト対象
    context "name、email、passwordのバリデーション" do
      #期待値
      it "name、email、passwordのバリデーションが通ること" do
        expect(user).to be_valid
      end
    end

    context "nameのバリデーション" do
      it "nameが空の場合はバリデーションする。" do
        user.name = ""
        expect(user).to_not be_valid
      end
    end

    context "emailのバリデーション" do
      it "emailが空の場合はバリデーションする。" do
        user.email = ""
        expect(user).to_not be_valid
      end
    end

    context "passwordのバリデーション" do
      it "passwordが空の場合はバリデーションする。" do
        user.password = ""
        expect(user).to_not be_valid
      end
      
      it "passwordが6文字以下の場合はバリデーションする。" do
        user.password = "hoge"
        expect(user).to_not be_valid
      end
    end

    context "一意性制約の確認" do
      before do
        user.save
        @duplicate = build(:user)
        @duplicate.email = user.email
      end

      it "既に登録されているemailで保存できない" do
        expect(@duplicate).to_not be_valid
      end

      it "emailが既に登録されている場合エラーメッセージが返される" do
        @duplicate.valid?
        expect(@duplicate.errors.full_messages).to include("メールアドレスはすでに存在します")
      end

    end
  end
end
