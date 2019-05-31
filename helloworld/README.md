localhost で起動する AmazonPay 仕様確認アプリ。

loocalhostで動かす場合、ログイン cookie の保持が仕様上難しいらしいので、ログイン周りでエラーでたらログアウトして再チャレンジ。

    # 環境変数で各種キー渡すこと
    $ export YOUR_MERCHANT_ID=
    $ export YOUR_ACCESS_KEY=
    $ export YOUR_SECRET_KEY=
    $ export YOUR_CLIENT_ID=

    $ bundle install
    $ bin/up

## TODO
- ユーザー情報の取得（ログイン時）OK
    - ID, Name, Email (optional: postal code)
    - [プロファイル情報の取得 | Amazon Pay Japan](https://developer.amazon.com/ja/docs/amazon-pay-onetime/obtain-profile.html)
- ワンタイム OK
- AutoPay OK
- ユースケース
    - ユーザーはログインしているか？ OK
        - JS で確認し、ログイン状態はアプリ側で持つのが良さそう
    - ユーザーはどのプランを購読しているか？
        - 情報はとれるが、管理機能があるわけではないので自前で持つ必要があるな
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
- JS SDK は auth を session にキャッシュする
    - When authorize receives a valid access token response, it automatically caches the token and associated metadata for reuse. This cache persists across page reloads and browser sessions. If a subsequent authorize call can be fulfilled by the cached token response, the SDK will reuse that token instead of requesting a new authorization. Use options.interactive to override this behavior.
    - バックエンドだけで処理していいものか悩ましい

## URL
- [Amazon Pay Self Check Sheet](https://pwa.geekylab.net/selfcheck/)
- [オーソリ処理エラーのシミュレーション](https://pwa.geekylab.net/selfcheck/case03-001.html)
- [PayAuto概要 | Amazon Pay Japan](https://developer.amazon.com/ja/docs/amazon-pay-automatic/intro.html)
- [amzn/amazon-pay-sdk-ruby: Amazon Pay Ruby SDK](https://github.com/amzn/amazon-pay-sdk-ruby)
- [Amazon Payの実装でつまづきやすいこと一覧 - Qiita](https://qiita.com/shg10/items/71f1eba9653732a7b45f)
- [Amazon Pay API Reference Guide | Amazon Pay Japan](https://developer.amazon.com/ja/docs/amazon-pay-api/intro.html)
- 英語のが最新 [Introduction | Amazon Pay](https://developer.amazon.com/docs/amazon-pay-api/intro.html)
- Amazon Pay and Login with Amazon integration guide [Which guide do you use? | Amazon Pay](https://developer.amazon.com/docs/amazon-pay-onetime/intro.html)
- Login with Amazon（LWA） [JavaScript用のLogin with Amazon SDKリファレンスガイド | Login with Amazon](https://developer.amazon.com/ja/docs/login-with-amazon/javascript-sdk-reference.html)
- Amazon Pay インテグレーションガイド [プロファイル情報の取得 | Amazon Pay Japan](https://developer.amazon.com/ja/docs/amazon-pay-onetime/obtain-profile.html#201953190)

## Hello World
0. 通常インテグレーションガイド
    - [Step 1:登録 | Amazon Pay Japan](https://developer.amazon.com/ja/docs/amazon-pay-onetime/register.html)
0. 付録インテグレーションガイド
    - [ログイン時での注文情報へのアクセス | Amazon Pay Japan](https://developer.amazon.com/ja/docs/amazon-pay-onetime/accessing-order-information.html)

## サンプル仕様メモ
- 認証許可 = amznログインをして許可をとる
- 決済開始 = widget利用可能
- 初回決済 = 認証あり、通知はメール
- 二回目決済 = 認証なし、通知はメール
