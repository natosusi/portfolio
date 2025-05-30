require 'rails_helper'

RSpec.describe Lending, type: :model do
  let(:lending) { create(:lending) }

  describe "バリデーションのテスト" do
    it "有効なデータであれば保存される" do
      expect(build(:lending)).to be_valid
    end

    context "schedule_dateのバリデーション" do
      it "schedule_dateが空の場合保存できない" do
        lending.schedule_date = ""
        expect(lending).to_not be_valid
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
