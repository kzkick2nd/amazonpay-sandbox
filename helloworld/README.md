## NOTE
- API = 上限ある？
- BI 系どうする？
- デジタルコンテンツから始める仮想仕様用意する？

## Hello World
0. 通常インテグレーションガイド
    - [Step 1:登録 | Amazon Pay Japan](https://developer.amazon.com/ja/docs/amazon-pay-onetime/register.html)
0. 付録インテグレーションガイド
    - [ログイン時での注文情報へのアクセス | Amazon Pay Japan](https://developer.amazon.com/ja/docs/amazon-pay-onetime/accessing-order-information.html)

## CONF, OPT
        # 環境変数で各種キー渡すこと
        $ export YOUR_MERCHANT_ID=
        $ export YOUR_ACCESS_KEY=
        $ export YOUR_SECRET_KEY=
        $ export YOUR_CLIENT_ID=

        # sinatra 起動
        $ bundle exec ruby hello_amznpay.rb

## サンプル仕様メモ
- 決済開始 = 画面あり
- 初回決済 = 認証あり、通知は？
- 二回目決済 = 認証なし、通知は？
- 都度情報取得
    - 管理者
        - 一覧
            - 絞り込み？
        - 詳細
            - 決済履歴
            - ステータス
    - ユーザー
        - 現在ステータス
        - 退会