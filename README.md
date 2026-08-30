# AI Development Platform

開発時に「何を守るか・何を選ぶか・どう設計するか・どう実装するか」へ適切にルーティングする統合入口です。

## 構成

```text
ai-dev-platform/
├── ai/
│   └── ONBOARDING.md       ← AIエージェントが最初に読むルーター
├── standards/               [git submodule: ai-dev-standards]
├── playbook/                [git submodule: ai-dev-playbook]
├── recommendations/
└── patterns/
```

## 各領域の役割

| 領域 | 問い | 場所 |
|---|---|---|
| Standards | 何を守る？ | [standards/](standards/) |
| Recommendations | 普段は何を選ぶ？ | [recommendations/](recommendations/) |
| Patterns | どう設計する？ | [patterns/](patterns/) |
| Playbook | どう実装する？ | [playbook/](playbook/) |
| UI Kit | 実際に使える部品は？ | application-ui-kit（独立リポジトリ） |
| Project Context / ADR | このプロジェクト固有ではどうする？ | 各プロジェクト側 |

同じ内容を複数箇所へ重複して記述しません。必要な場合は相互参照します。

## 利用方法

### プロジェクトからの参照

各プロジェクトの `CLAUDE.md` 等のAI設定ファイルから `ai/ONBOARDING.md` へのパスを記載して参照させます。

```markdown
<!-- 各プロジェクトの CLAUDE.md への記載例 -->
開発Standardは ../ai-dev-platform/ai/ONBOARDING.md を最初に読むこと。
```

### ワークスペースの配置例

```text
workspace/
├── ai-dev-platform/
│   ├── standards/
│   ├── playbook/
│   ├── recommendations/
│   └── patterns/
│
├── application-ui-kit/
├── dx-portal/
├── directory/
└── ...
```

## application-ui-kit との関係

UI Kitは本リポジトリのsubmoduleにはしません。独立したリポジトリ・パッケージとして維持します。

UI Kitは参照用知識ではなく、各Applicationが実際に依存するソフトウェアパッケージです。各Applicationで使用しているUI Kitのバージョンについては、そのApplicationの `package.json` / lockfile を Source of Truth とします。

## 知識の成熟

最初からすべてをStandardや共通実装にしません。

```text
Project固有の実装・判断
        ↓
複数回利用して有効だった
        ↓
Pattern / Playbook / Recommendation
        ↓
さらに繰り返し実装される
        ↓
必要ならUI Kit等として共通実装
        ↓
不一致による実害が大きい
        ↓
必要な場合のみStandard
```

Standardへの昇格は慎重にします。PatternやRecommendationとして十分であれば、Standardにする必要はありません。

## このリポジトリに置かないもの

- UIコンポーネント、デザインシステム、Storybook（application-ui-kitの責務）
- 社員・組織・認証基盤などの業務ドメイン固有情報（各プロジェクトの責務）
- 新規プロジェクト用テンプレートやボイラープレート
- AIエージェント定義、モデル設定、複雑なワークフロー実行基盤
