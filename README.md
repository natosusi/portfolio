# library-record

社内や身近な人の書籍の**貸出・返却管理**を行うWebアプリケーションです。  
貸した・借りた書籍の状況が可視化されることで、管理者不在でも簡単に本の貸し借りが完結します。
<img width="1920" height="968" alt="Library-record_top" src="https://github.com/user-attachments/assets/8a4b79ec-297b-4036-9b98-a6b6208f6e51" />

---

## アプリURL
https://library-record-b4c6e8f9189b.herokuapp.com/

---
## 📚 目的

- 書籍の貸出・返却を記録・管理
- 誰が何を借りているか、返却予定日がいつかを可視化
- 管理担当者不在でも、借りる人だけで完結可能

---

## 🛠 開発環境

- Ruby 3.4.2
- Rails 7.2.2.1
- Docker

---

## 🚀 主な機能

- ログイン／ログアウト
- 会員登録
- 貸出登録／返却登録
- お気に入り登録・お気に入り一覧の確認
- 貸出履歴の確認
- レビュー投稿
- 返却期限当日の通知（アプリ内）
- 返却期限前日の通知（メール）

**管理者のみ：**
- 書籍検索・登録
- 管理画面(rails_admin)

---

## 📝 基本的な使い方
#### 管理者アカウント
- メールアドレス：hoge@example.com
- パスワード：8uhbnji9

#### 一般ユーザーアカウント
- メールアドレス：testuser1@example.com
- パスワード：9ijnbhu8

### 書籍の登録（管理者）

1. 管理者アカウントでログイン  
2. 書籍検索・登録画面でISBN（13桁）を入力し「検索」
<img width="1920" height="968" alt="Library-record_admin_search" src="https://github.com/user-attachments/assets/1a431cb7-cf9e-4743-bc7e-a98b51a9ddc9" />

3. 検索結果を確認し「書籍登録」ボタンでアプリ内に書籍の情報を登録
<img width="1920" height="968" alt="Library-record_save" src="https://github.com/user-attachments/assets/45bbd8fc-23d2-4e5c-badd-83a2360bd69b" />
<img width="1920" height="968" alt="Library-record_save2" src="https://github.com/user-attachments/assets/ed34ca87-d0fb-42ba-8555-2e7a6204ba95" />

### 本を借りる（一般ユーザー）

1. 一般ユーザーでログイン  
2. 書籍一覧から希望の本を選び「借りる」ボタンを押す
<img width="1920" height="968" alt="Library-record_lending" src="https://github.com/user-attachments/assets/46b029f6-baa1-478a-abf4-1c1a1e1356a3" />

3. 返却予定日を指定して貸出登録
<img width="1920" height="968" alt="Library-record_lending2" src="https://github.com/user-attachments/assets/4dee20e6-99ab-4f68-ab6f-f087534dcfab" />
<img width="1920" height="968" alt="Library-record_lending3" src="https://github.com/user-attachments/assets/edd8f339-2a6d-40b1-a86f-e02618071596" />


### 本を返却

1. ログイン後、書籍一覧または会員詳細ページの貸出履歴から「返却」ボタンで返却登録
<img width="1920" height="968" alt="Library-record_return" src="https://github.com/user-attachments/assets/aa3ee70e-7fa7-4553-822b-b6cfd5637295" />
<img width="1920" height="968" alt="Library-record_return2" src="https://github.com/user-attachments/assets/135a4169-f516-40b5-a5ea-23cf91ed6790" />


---

## 🗂 今後の課題・追加予定機能

- アプリ内の書籍検索機能
- 書籍一覧のソート
- レビュー評価機能（共感・役に立った等）
- 書籍のカテゴリー管理

---

## ⚠️ 備考

- アカウント登録・メールアドレス変更時のメール認証、返却期限メール通知は**現在、開発環境のみ**です（実際のメール送信は行われません）。

---

## 初期構築

1. library-record 配下に.env に API_KEY コピー
2. docker compose run webapp bundle install
3. docker compose build
4. docker compose run --rm webapp rails assets:precompile
5. docker compose run webapp rails db:reset
6. docker compose up
