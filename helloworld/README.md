## TODO
- ユーザー情報の取得（ログイン時）
- ワンタイム
    - 決済の完了
    - レスポンス表示
    - 購入内容の参照
- AutoPay
    - 決済の完了
    - 二回目決済の実行
        - 自動実行
    - レスポンス表示
    - 契約内容の参照
- ユースケース
    - ユーザーはログインしているか？
    - ユーザーはどのプランを購読しているか？

## NOTE
- API = 上限ある？
    - 本番環境では、この処理の最大リクエストクォーターは10であり、回復レートは1秒間に1回です。SANDBOX環境では、最大リクエストクォーターは2であり、回復レートは2秒間に1回です。
        - https://developer.amazon.com/ja/docs/amazon-pay-api/setorderreferencedetails.html
        - https://developer.amazon.com/ja/docs/eu/amazon-pay-api/throttling-limits.html
        - バッファは欲しい
- https を必須とする箇所が多くローカル開発で注意が必要である。
- BI 系どうする？
- デジタルコンテンツから始める仮想仕様用意する？
- ステート[Order Reference状態と理由コード | Amazon Pay Japan](https://developer.amazon.com/ja/docs/amazon-pay-api/order-reference-states-and-reason-codes.html)
    - ステート Draft => Open には ConfirmOrderReference
- pay_with_amazon は古い gem っぽい
- 同期オーソリ、非同期オーソリ
- > response = client.client.get_merchant_account_status 間違いライン？
- region を指定しないと deny される

## URL
- [Amazon Pay Self Check Sheet](https://pwa.geekylab.net/selfcheck/)
- [オーソリ処理エラーのシミュレーション](https://pwa.geekylab.net/selfcheck/case03-001.html)

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

        # local app 起動
        $ bin/up

## サンプル仕様メモ
- 認証許可 = amznログインをして許可をとる
- 決済開始 = widget利用可能
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