# テーブルスキーマ 2021.3.1

以下にモデル名, カラム名, データ型を記載します。（ER図: docs/ER_diagram.png）
- User name:string, email:string
- Task name:string, description:text, user:references, deadline:datetime, priority:integer, status:string
- Label name:string, image:text
- Labelling task:references, label:references

# herokuへのデプロイ方法 2021.3.3

## アセットプリコンパイルする ##
>     $ rails assets:precompile RAILS_ENV=production

## コミットする(step2ブランチにて) ##
>     $ git add -A
>     $ git commit -m "do asset precompile for heroku deploy"

## Herokuのアプリケーションを作成する ##
>     $ cd ~/workspace/manyo_work
>     $ heroku create
>     Creating app... done, ? fathomless-springs-40669
>     https://fathomless-springs-40669.herokuapp.com/ | https://git.heroku.com/fathomless-springs-40669.git


## Heroku stackを変更する ##
>     $ heroku stack:set heroku-18

## Heroku buildpackを追加する ##

>     $ heroku buildpacks:set heroku/ruby
>     $ heroku buildpacks:add --index 1 heroku/nodejs  

## Herokuにデプロイする ##
>     $ git push heroku step2:master

## データベース移行 ##
>      $ heroku run rails db:migrate

## 環境変数を設定する ##
>     heroku config:set BASIC_AUTH_USER=xxx
>     heroku config:set BASIC_AUTH_PASSWQORD=yyy
