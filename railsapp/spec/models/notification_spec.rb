require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { create(:notification) }

  describe "バリデーションのテスト" do
    it "有効なデータであれば保存される" do
      expect(build(:notification)).to be_valid
    end

    context "action_typeのバリデーション" do
      before do
        notification = create(:notification)
      end

      it "action_typeが空の場合保存できない" do
        notification.action_type = ""
        expect(notification).to_not be_valid 
      end

      it "1つのlendingで同じaction_typeは保存できない" do
        duplicate = build(:notification,lending: notification.lending, action_type: notification.action_type)
        expect(duplicate).to_not be_valid
      end
    end
  end

  describe "アソシエーションのテスト" do

    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "userとの関連付けはbelongs_toであること" do
      let(:target) { :user }
      it { expect(association.macro).to eq :belongs_to }
    end

    context "lendingとの関連付けはbelongs_toであること" do
      let(:target) { :lending }
      it { expect(association.macro).to eq :belongs_to }
    end

  end

end
