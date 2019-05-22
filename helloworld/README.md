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

        # localhost 起動
        $ ruby -run -e httpd . -p 8000