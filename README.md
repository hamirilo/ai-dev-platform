# AI Development Platform

開発時に「何を守るか・何を選ぶか・どう実装するか」へ適切にルーティングする統合入口です。

UI/UXの設計・実装については、独立した **ui-platform** を参照します。

## 構成

```text
ai-dev-platform/
├── ai/
│   └── ONBOARDING.md       ← AIエージェントが最初に読むルーター
├── standards/               [git submodule: ai-dev-standards]
├── playbook/                [git submodule: ai-dev-playbook]
└── recommendations/
```

## 各領域の役割

| 領域 | 問い | 場所 |
|---|---|---|
| Standards | 何を守る？ | [standards/](standards/) |
| Recommendations | 普段は何を選ぶ？ | [recommendations/](recommendations/) |
| Playbook | どう実装・検証する？ | [playbook/](playbook/) |
| UI Platform | UIをどう設計・実装する？ | [jazmf-dx/ui-platform](https://github.com/jazmf-dx/ui-platform) |
| Project Context / ADR | このプロジェクト固有ではどうする？ | 各プロジェクト側 |

同じ内容を複数箇所へ重複して記述しません。必要な場合は相互参照します。

## 利用方法

### プロジェクトからの参照

各プロジェクトの `CLAUDE.md` 等のAI設定ファイルから `ai/ONBOARDING.md` へのパスを記載して参照させます。

```markdown
<!-- 各プロジェクトの CLAUDE.md への記載例 -->
開発Standardは ../ai-dev-platform/ai/ONBOARDING.md を最初に読むこと。
```

### submodule の初期化（必須）

`standards/` と `playbook/` はsubmoduleです。**初期化していないと空ディレクトリのままで、
ルーターが指す先を一切読めません。**

```bash
# 新規に取得する場合
git clone --recurse-submodules https://github.com/jazmf-dx/ai-dev-platform.git

# すでにcheckout済みの場合
git submodule update --init --recursive
```

submoduleを更新するときは `git submodule update --remote` ではなく、対象リポジトリで
確認したcommit（release tag）を指すようにpinします。

### ワークスペースの配置例

```text
workspace/
├── ai-dev-platform/
│   ├── standards/
│   ├── playbook/
│   └── recommendations/
│
├── ui-platform/
├── dx-portal/
├── directory/
└── ...
```

## ui-platform との関係

`ui-platform` は本リポジトリのsubmoduleにはしません。独立したリポジトリとして維持します。

UIに関する責務は `ui-platform` に集約します。

- **Components**: 各Applicationが実際に利用する再利用可能なUI部品
- **Patterns**: 同じUX課題に対する設計候補と選択条件
- **Templates**: 複数Patternを組み合わせた画面レベルの構成例
- **Catalog / Storybook**: Component・Pattern・Templateを見て比較・検証する表示面

実際にApplicationが利用するpackageは `@<owner>/application-ui-kit` です。scopeは`ui-platform`のpublishワークフローがリポジトリ所有者から導出するため、この組織では `@jazmf-dx/application-ui-kit` になります（`ui-platform` の `package.json` に書かれているscopeは公開時に書き換えられるので、そのまま利用側の名前にはなりません）。packageのバージョンについては、対象Applicationの `package.json` / lockfile を Source of Truth とします。

AIがUIを扱う場合は、対象Applicationのpackage versionを確認したうえで `ui-platform` のComponent / Pattern / Template / Storybookを必要に応じて参照してください。

## 知識の成熟

最初からすべてをStandardや共通実装にしません。

```text
Project固有の実装・判断
        ↓
複数回利用して有効だった
        ↓
Recommendation / Playbook
        ↓
UIに関する再利用可能な判断・実装なら ui-platform
        ↓
不一致による実害が大きい
        ↓
必要な場合のみStandard
```

Standardへの昇格は慎重にします。Recommendation、Playbook、またはui-platformで十分であればStandardにする必要はありません。

## このリポジトリに置かないもの

- UIコンポーネント、UI Pattern、Template、Storybook（ui-platformの責務）
- 社員・組織・認証基盤などの業務ドメイン固有情報（各プロジェクトの責務）
- 新規プロジェクト用テンプレートやボイラープレート
- AIエージェント定義、モデル設定、複雑なワークフロー実行基盤
