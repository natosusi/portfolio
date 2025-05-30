require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:like) { create(:like) }

  describe "バリデーションのテスト" do

    context "user_idのバリデーション" do
      before do
        like = create(:like)
      end

      it "1つのuser_idで同じbook_idを保存できない" do
        duplicate = build(:like, user_id: like.user, book_id: like.book)
        expect(duplicate).to_not be_valid
      end

      it "user_idが同じでも違うbook_idなら保存できる" do
        expect(create(:like, user_id: like.user_id)).to be_valid
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
