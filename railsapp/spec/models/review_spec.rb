require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:review) { create(:review) }

  describe "バリデーションのテスト" do
    it "有効なデータであれば保存される" do
      expect(build(:review)).to be_valid
    end

    context "titleのバリデーション" do
      it "titleが空の場合保存できない" do
        review.title = ""
        expect(review).to_not be_valid
      end
    end

    context "commentのバリデーション" do
      it "commentが空の場合保存できない" do
        review.comment = ""
        expect(review).to_not be_valid
      end
    end

  end

  describe "アソシエーションのテスト" do

    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "bookとの関連付けはbelongs_toであること" do
      let(:target) { :book }
      it { expect(association.macro).to eq :belongs_to }
    end

    context "userとの関連付けはbelongs_toであること" do
      let(:target) { :user }
      it { expect(association.macro).to eq :belongs_to }
    end

  end

end
