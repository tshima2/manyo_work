# テーブルスキーマ 2021.3.1

以下にモデル名, カラム名, データ型を記載します。（ER図: docs/ER_diagram.png）
- User name:string, email:string
- Task name:string, description:text, user:references, deadline:datetime, priority:integer, status:string
- Label name:string, image:text
- Labelling task:references, label:references



