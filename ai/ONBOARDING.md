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
5. 新しいStandardやレイアウト・共通実装を「将来使うかもしれない」という理由だけで増やさないこと。
6. **新しいライブラリ・パッケージを追加する前に [Recommendations](../recommendations/) を確認すること。** 未収録のものを導入する場合は、健全性チェックの結果を短く提示してから追加すること。
7. **実装に入る前に、対象プロジェクトの `decisions/project-context.md` があれば読むこと。** 対象ユーザー、認証の要否、主対象デバイス、認可の粒度といった前提を勝手に仮定しないこと。存在しない場合でも無関係な小規模修正は止めず、前提がタスクの設計を実質的に左右する場合だけ確認すること。その他のプロジェクト側ADRは、関連するタスクを扱う場合のみ読むこと。
8. **詳細な実装手順や検証方法をStandardへ追加しないこと。** 必要な場合は [Playbook](../playbook/) を参照し、再利用可能なUI設計・実装はapplication-ui-kitを参照すること。どちらも該当タスクのときだけ読むこと。
9. **対象プロジェクトで定義されている型チェック、Linter、Build、基本テストを通過させること。** これらは該当する場合、PR・マージ・リリースの必須ゲートです。

---

## 参照先（ルーター）

### 1. ルール・制約 → Standards

開発フロー・ガバナンス・Git運用、バックエンド・技術構成・認証・ログ・API、フロントエンド・画面構造・操作の一貫性について:

👉 [Standards](../standards/)

- [Governance & Rules](../standards/standards/governance/) — AI利用方針、Git運用、Standard逸脱時のルール
- [Architecture Standard](../standards/standards/architecture/) — Django構成、認可、Security、Logging、Testing
  - React Islands・TypeScript を扱う場合は [TypeScript Standard](../standards/standards/architecture/typescript.md) も読むこと
  - Docker Compose のポート公開を扱う場合は [Container Network](../standards/standards/architecture/optional/container-network.md) も読むこと
- [Application UI Standard](../standards/standards/application-ui/) — レイアウト、通知、エラー表示、フォームUX、shadcn/ui

AIはOptional Standardを先回りしてすべて読まず、該当する場合のみ参照すること。

### 2. ライブラリ・技術選定 → Recommendations

動画、画像、チャート、地図、アイコン等、`shadcn/ui` で解決しない領域の既定、信頼境界の実行時検証、非推奨ライブラリについて:

👉 [Recommendations](../recommendations/)

依存を追加・変更する場合のみ読むこと。Standardと異なり拘束力は弱く、逸脱にADRを求めない。

### 3. UI/UX・設計パターン → Patterns

UI/UXの設計に迷ったとき、過去に検討した良いパターンを参照する:

👉 [Patterns](../patterns/)

該当するパターンがある場合のみ参照すること。

### 4. 実装方法・検証・障害対応 → Playbook

詳細な実装手順、検証方法、失敗例:

👉 [Playbook](../playbook/)

タスクに必要なPlaybookだけを読むこと。

### 5. UI実装 → application-ui-kit

UIを実装するプロジェクトがapplication-ui-kitを採用している場合:

1. **対象Applicationの `package.json` 等から実際のUI Kit versionを確認する**
2. 必要に応じて `application-ui-kit` リポジトリを参照する
   - `design-system/`: 設計参照
   - UI package: 再利用可能な実装
   - Storybook: 使用例・状態確認・視覚検証
3. UI/UX設計に迷う場合は [Patterns](../patterns/) を参照する

業務ドメイン固有のUIは、各アプリまたはドメイン所有側で管理する。

---

## 必須基準と品質推奨

### 必須基準

対象プロジェクトで定義されている型チェック（TypeScriptでは `tsc --noEmit` 等）、Linter、Build、基本テストは、該当する場合にPR・マージ・リリースの必須ゲートとします。CIで自動検証し、エラーを解消してから先へ進みます。

### 品質推奨

性能、アクセシビリティ、実ブラウザでの操作性を高める確認は [Quality Recommendations](../recommendations/quality.md) を参照してください。Lighthouse、Core Web Vitals、N+1クエリ対策はSoft Targetであり、通常はリリースブロッカーにしません。

AIエージェントは品質推奨を常時適用せず、ユーザーから明示的な指示がある場合、または大規模なUI・パフォーマンス変更を行う場合に参照・適用します。実施手順は [Playbook](../playbook/) から該当する手順を参照します。

---

## Standardを増やそうとしたとき

追加基準と配置先（Core / Optional / Recommendation / Pattern / Shared implementation / Project側）の判断は、[ADR-0003](../standards/decisions/adr-0003-core-and-optional-standards.md) を正として従ってください。繰り返しが確認されていないものを先回りしてStandard化しません。

## 実装資産について

本リポジトリは「判断の再利用」と「入口の統合」を扱い、実装コードは含みません。
実装資産の境界は [ADR-0004](../standards/decisions/adr-0004-shared-asset-boundaries.md) を参照してください。
