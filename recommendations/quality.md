# 品質向上の推奨チェック

この文書はStandardではありません。すべての画面に同じ検査を要求するのではなく、利用者への影響が大きい画面や変更に対して、品質を上げるために確認したほうがよい項目と目標値をまとめます。

## 必須基準との境界

型チェック、Linter、Build、基本テストは、対象プロジェクトに定義されている場合、Governance Standardの必須ゲートです。この文書ではそれらをSoft Targetとして扱いません。

この文書で扱うのは、必須ゲートを通過したうえで、変更規模や画面の重要度に応じて行う品質向上の推奨確認です。AIはユーザーから明示的な指示がある場合、または大規模なUI・パフォーマンス変更時に参照・適用します。

## RecommendationとPlaybookの分担

この文書は **何を目標にするか** だけを持ちます。代表ページの選び方、測定条件、実装品質の確認方法、実ブラウザでの操作確認、結果の報告項目、実施するタイミングは [品質確認Playbook](../playbook/playbooks/quality-checks.md) が扱います。ここへ手順を重複して記載しません。

## 基本方針

- LighthouseのPerformance、Accessibility、Best Practicesは100を目標にする。
- ただし100点をリリースゲートにしない。Lighthouseは実験室計測であり、公式にも90〜100が良好な範囲、100は達成が難しい値とされています。
- スコアを上げるために、必要な機能、意味のあるラベル、利用者に必要な情報を削らない。
- 点数だけでなく、実際の利用者が主要操作を完了できるかを優先する。

## Lighthouse

| カテゴリ | 推奨する扱い |
|---|---|
| Performance | 100を目標にし、少なくとも90以上を目安に改善箇所を確認する |
| Accessibility | 100を目標にし、重大なアクセシビリティ問題を残さない |
| Best Practices | 100を目標にする |
| SEO | 外部公開・検索流入が必要なページだけ確認する。社内限定画面では適用しない |

## Core Web Vitals

Lighthouseのスコアとは別に、実際の利用体験を表す指標を確認します。良好な目安は次のとおりです。

- LCP: 2.5秒以内
- INP: 200ミリ秒以内
- CLS: 0.1以下

## UIとアクセシビリティ

該当する画面・コンポーネントで満たす条件です。

- キーボードだけで主要操作を完了できる
- フォーカス位置が見え、ダイアログやメニューを閉じた後の戻り先が自然である
- ボタン、入力欄、アイコン操作に役割と名前がある
- エラーが色だけに依存せず、何を直せばよいか分かる
- 長い文字列、空状態、エラー状態、読み込み中でもレイアウトが破綻しない
- モバイル幅・狭い画面幅でも主要操作が隠れない
- 動きが必要以上に強くなく、reduced motionの設定を妨げない
- 画像やアイコンが意味を持つ場合は代替テキストや適切なラベルがある

## 日時の取り扱いの検査

[Architecture Standard「時刻・タイムゾーン」](../standards/standards/architecture/README.md#時刻タイムゾーン) が禁じる誤用パターンは、次の設定で機械的に検出できます。いずれも既存のLinter・テスト設定への数行の追加であり、画面単位の確認ではなくプロジェクトへの一度きりの導入です。日付境界の不具合は1日の特定時間帯しか再現しないため、レビューとテストだけに頼らずCIで止めます。

- **ruffのDTZルール（flake8-datetimez）を有効にする。** `date.today()`（DTZ011）、naiveな `datetime.now()`（DTZ005）、naive datetimeの生成（DTZ001）を検出する。
- **naive datetimeの `RuntimeWarning` をテストでエラー扱いにする。** pytestの `filterwarnings` へ `error:.*received a naive datetime` を追加する。フィクスチャ経由の混入もマージ前に止まる。
- **`timezone.now().date()` をCIで検出する。** このパターンを検出する既製のlintルールはないため、grep等の1行で代用する。変数へ代入してから `.date()` を呼ぶ形は検出できないが、実際の混入の大半はリテラル形である。

```bash
! grep -rn "timezone\.now()\.date()" --include="*.py" apps/
```

## 参照

- [Introduction to Lighthouse](https://developer.chrome.com/docs/lighthouse/overview)
- [Lighthouse performance scoring](https://developer.chrome.com/docs/lighthouse/performance/performance-scoring)
- [Web Vitals](https://web.dev/articles/vitals)
