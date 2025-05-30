require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { build(:book) }

  describe "バリデーションのテスト" do
    it "有効なデータであれば保存される" do 
      expect(book).to be_valid
    end

    context "titleのバリデーション" do
      it "titleが空の場合保存できない" do
        book.title = ""
        expect(book).to_not be_valid
      end
    end

    context "authorのバリデーション" do
      it "authorが空の場合保存できない" do
        book.author = ""
        expect(book).to_not be_valid
      end
    end

    context "descriptionのバリデーション" do
      it "descriptionが空の場合保存できない" do
        book.description = ""
        expect(book).to_not be_valid
      end
    end

    context "image_linkのバリデーション" do
      it "image_linkが空の場合保存できない" do
        book.image_link = ""
        expect(book).to_not be_valid
      end
    end
  end

  describe "アソシエーションのテスト" do

    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "lendingモデルとの関連付けはhas_manyであること" do
      let(:target) {(:lendings)}
      it { expect(association.macro).to eq :has_many }
    end

    context "reviewモデルとの関連付けはhas_manyであること" do
      let(:target) {(:reviews)}
      it { expect(association.macro).to eq :has_many }
    end

    context "likeモデルとの関連付けはhas_manyであること" do
      let(:target) {(:likes)}
      it { expect(association.macro).to eq :has_many }
    end

  end

end
