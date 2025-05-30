require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) {build(:book)}

  describe "バリデーションのテスト" do

    context "title、author、description、image_linkのバリデーション" do
      it "title、author、description、image_linkのバリデーションが通る" do 
        expect(book).to be_valid
      end
    end

    context "titleのバリデーション" do
      it "titleが空の場合バリデーションする" do
        book.title = ""
        expect(book).to_not be_valid
      end
    end

    context "authorのバリデーション" do
      it "authorが空の場合バリデーションする" do
        book.author = ""
        expect(book).to_not be_valid
      end
    end

    context "descriptionのバリデーション" do
      it "descriptionが空の場合バリデーションする" do
        book.description = ""
        expect(book).to_not be_valid
      end
    end

    context "image_linkのバリデーション" do
      it "image_linkが空の場合バリデーションする" do
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
