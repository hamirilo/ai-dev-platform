# AI エージェント オンボーディング

> 本リポジトリは、開発における「判断のブレ」を減らすための統合入口です。
> AI エージェント（Claude / Codex / Gemini 等）がプロジェクトに参加するとき、**最初にこのファイルのみを読みます**。
> 各プロジェクトへは、そのプロジェクトの `CLAUDE.md` 等に本ファイルへのパスを記載して参照させます。

---

## 必守事項

1. **既存Standardを確認してから新しい判断を行うこと。**
2. **既存Component / 採用済みのShared UI実装がある場合は再実装しないこと。**
3. 最初からすべてのドキュメントを読まないこと。**タスクに必要なCore Standardだけを読み、Optional Standardは該当機能を扱う場合のみ読むこと。**
4. Standardから重要な逸脱をする場合は、プロジェクト側で理由（ADR等）を残すこと。
5. 新しいStandardやレイアウト・共通実装を「将来使うかもしれない」という理由だけで増やさないこと。**有用なベストプラクティスであることだけでも追加理由にはならない。既存ルールへの統合、Standard外への配置、追加しない判断を先に検討すること。**
6. **新しいライブラリ・パッケージを追加する前に [Recommendations](../recommendations/) を確認すること。** 未収録のものを導入する場合は、健全性チェックの結果を短く提示してから追加すること。
7. **実装に入る前に、対象プロジェクトの `decisions/project-context.md` があれば読むこと。** 対象ユーザー、認証の要否、主対象デバイス、認可の粒度といった前提を勝手に仮定しないこと。存在しない場合でも無関係な小規模修正は止めず、前提がタスクの設計を実質的に左右する場合だけ確認すること。その他のプロジェクト側ADRは、関連するタスクを扱う場合のみ読むこと。
8. **詳細な実装手順や検証方法をStandardへ追加しないこと。** 必要な場合は [Playbook](../playbook/) を参照すること。UI/UXの設計・再利用可能なUI実装・Pattern・Template・Catalogは `ui-platform` を参照すること。いずれも該当タスクのときだけ読むこと。
9. **対象プロジェクトで定義されている型チェック、Linter、Build、基本テストを通過させること。** これらは該当する場合、PR・マージ・リリースの必須ゲートです。
10. **Standard適合レビューをプロジェクト全体の改善監査へ拡張しないこと。** 既存実装が現在のStandardと異なるだけなら原則として一括移行を要求せず、新規・変更箇所から寄せる。品質向上、近代化、追加機能はStandard適合作業と分離すること。

---

## 参照先（ルーター）

### 1. ルール・制約 → Standards

開発フロー・ガバナンス・Git運用、バックエンド・技術構成・認証・ログ・API、フロントエンド・画面構造・操作の一貫性について:

👉 [Standards](../standards/)

- [Governance & Rules](../standards/standards/governance/) — AI利用方針、Git運用、Standard逸脱時のルール
  - リポジトリの立ち上げや、既存リポジトリのStandard適合を行う場合のみ、Governanceから [Project Setup](../standards/standards/governance/optional/project-setup.md) へ進むこと
- [Architecture Standard](../standards/standards/architecture/) — Django構成、認可、Security、Logging、Testing
  - React Islands・TypeScript を扱う場合は [TypeScript Standard](../standards/standards/architecture/typescript.md) も読むこと
  - Docker Compose のポート公開を扱う場合は [Container Network](../standards/standards/architecture/optional/container-network.md) も読むこと
  - 共通ダッシュボード向けのStatus APIを実装・利用する場合は [Status API](../standards/standards/architecture/optional/status-api.md) も読むこと
- [Application UI Standard](../standards/standards/application-ui/) — レイアウト、通知、エラー表示、フォームUX、shadcn/ui

AIはOptional Standardを先回りしてすべて読まず、該当する場合のみ参照すること。

### 2. ライブラリ・技術選定 → Recommendations

動画、画像、チャート、地図、アイコン等、`shadcn/ui` で解決しない領域の既定、信頼境界の実行時検証、非推奨ライブラリについて:

👉 [Recommendations](../recommendations/)

依存を追加・変更する場合のみ読むこと。Standardと異なり拘束力は弱く、逸脱にADRを求めない。

### 3. UI/UX設計・UI実装 → ui-platform

UIを設計・実装するときは、独立リポジトリ [ui-platform](https://github.com/jazmf-dx/ui-platform) を参照する。

`ui-platform` の責務:

- **Components** — 実際に利用する再利用可能なUI部品
- **Patterns** — 同じUX課題に対する設計候補と選択条件
- **Templates** — 複数Patternを組み合わせた画面レベルの構成例
- **Catalog / Storybook** — Component・Pattern・Templateを見て比較・検証する表示面

AIがUIタスクを扱う場合:

1. 対象Applicationが `@<owner>/application-ui-kit` を利用しているか確認する（scopeはpublish時にリポジトリ所有者から導出されるため、この組織では `@jazmf-dx/application-ui-kit`）
   - **利用している場合**: `package.json` / lockfileから実際のversionを確認し、そのversionを実装上のSource of Truthとする
   - **利用していない場合**: version確認は不要。`ui-platform` のPattern / Template / Catalogを設計参照として利用し、UI Kit導入を自動的に前提としない
2. 新しいUIを作る前に、`ui-platform` の既存Component / Pattern / Templateを確認する
3. UX上の選択に迷う場合はPatternを参照する
4. 画面全体の構成を検討する場合はTemplateを参照する
5. 実際の見た目・状態・操作を確認する場合はStorybook Catalogを参照する
6. UI Kit採用済みのApplicationで既存Componentにより解決できる場合は再実装しない

`ui-platform` 自体はApplicationの依存versionのSource of Truthではない。実際にUI Kitを利用している場合、そのpackage versionは対象Application側を正とする。

業務ドメイン固有のUIは、各アプリまたはドメイン所有側で管理する。

### 4. 実装方法・検証・障害対応 → Playbook

詳細な実装手順、検証方法、失敗例:

👉 [Playbook](../playbook/)

タスクに必要なPlaybookだけを読むこと。

---

## 必須基準と品質推奨

### 必須基準

対象プロジェクトで定義されている型チェック（TypeScriptでは `tsc --noEmit` 等）、Linter、Build、基本テストは、該当する場合にPR・マージ・リリースの必須ゲートとします。CIで自動検証し、エラーを解消してから先へ進みます。

### 品質推奨

性能、アクセシビリティ、実ブラウザでの操作性を高める確認は [Quality Recommendations](../recommendations/quality.md) を参照してください。Lighthouse、Core Web Vitals、N+1クエリ対策、高度なパフォーマンス最適化はSoft Targetであり、通常はリリースブロッカーにしません。

AIエージェントは品質推奨を常時適用せず、ユーザーから明示的な指示がある場合、または大規模なUI・パフォーマンス変更を行う場合に参照・適用します。実施手順は [Playbook](../playbook/) から該当する手順を参照します。

---

## 既存プロジェクトをレビューするとき

Standardは原則として今後の判断、新規実装、変更箇所へ適用します。既存コードとの差分をすべて修正することを「適合」とみなしません。

レビュー結果は次の3種類に分けます。

1. **Required**: 今回の新規・変更箇所でStandardに反するもの、またはセキュリティ、データ整合性、必須CIゲート等に関わり現在の問題として修正が必要なもの。
2. **Adopt going forward**: 変更対象外の既存方式が現在のStandardと異なるもの。直ちに一括移行せず、今後その箇所を変更するときにStandardへ寄せる。
3. **Optional improvement**: 品質向上、近代化、追加機能等。Standard適合とは分離し、必要なら通常のBacklogとして扱う。

Optional Standardの発動条件に該当することは、その機能を新たに実装する義務を意味しません。例えばStatus APIのStandardが存在していても、Standardレビューだけを理由にStatus API機能を追加しません。

---

## Standardを増やそうとしたとき

追加基準と配置先（Core / Optional / Recommendation / Shared implementation / Project側）の判断は、[ADR-0003](../standards/decisions/adr-0003-core-and-optional-standards.md) を正として従ってください。UI Pattern / Template / Catalogは `ui-platform` の責務です。繰り返しが確認されていないものを先回りしてStandard化しません。

新しい項目を提案する前に、**「追加しない場合に現在どのような繰り返しや実害があるか」**を確認してください。説明できない場合はStandardへ追加しません。

## 実装資産について

本リポジトリは「判断の再利用」と「入口の統合」を扱い、実装コードは含みません。
実装資産の境界は [ADR-0004](../standards/decisions/adr-0004-shared-asset-boundaries.md) を参照してください。
共有資産のリポジトリをフォークして使っている場合は、フォークへ組織固有の差分を足さないでください（[ADR-0005](../standards/decisions/adr-0005-upstream-fork-operation.md)）。
