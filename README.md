# AI Development Platform

開発時に「何を守るか・何を選ぶか・どう実装するか」へ適切にルーティングする **統合入口（composition root）** です。

Platform自体へすべての知識・実装を集約するのではなく、役割ごとに分離された資産を、Applicationから一貫した入口で利用できるようにします。

UI/UXの設計・実装については、独立した **ui-platform** を参照します。

## 構成

```text
ai-dev-platform/
├── ai/
│   └── ONBOARDING.md       ← AIエージェントが最初に読む唯一の入口
├── docs/
│   └── adoption.md         ← Platformの初回導入・既存Applicationへの適用
├── standards/              [git submodule: ai-dev-standards]
├── playbook/               [git submodule: ai-dev-playbook]
└── recommendations/        ← 現時点の選択の正本
```

## 各領域の役割

| 領域 | 問い | 場所 |
|---|---|---|
| Standards | 何を守る？ | [standards/](standards/) |
| Recommendations | 普段は何を選ぶ？ | [recommendations/](recommendations/) |
| Playbook | どう実装・移行・検証する？ | [playbook/](playbook/) |
| UI Platform | UIをどう設計・実装する？ | [hamirilo/ui-platform](https://github.com/hamirilo/ui-platform) |
| Project Context / ADR | このプロジェクト固有ではどうする？ | 各Application側 |

同じ内容を複数箇所へコピーしません。Standardは判断、Playbookは実施、Recommendationは現在の選択、Platformは入口と組合せを担当します。

## Quick Start

### 1. Platformをcloneする

ワークスペースへsubmodule込みで取得します。

```bash
git clone --recurse-submodules git@github.com:hamirilo/ai-dev-platform.git
```

通常のcloneを行った場合は、次で初期化します。

```bash
cd ai-dev-platform
git submodule update --init --recursive
```

### 2. ApplicationからPlatform ONBOARDINGを参照する

各Applicationの `CLAUDE.md` 等のAI設定ファイルへ、Platform側の `ai/ONBOARDING.md` を最初に読むよう記載します。

```markdown
開発Standard・Recommendations・Playbookは
../ai-dev-platform/ai/ONBOARDING.md
を最初に参照すること。
```

実際の相対パスはワークスペース構成に合わせます。

Applicationへ `ai-dev-standards` / `ai-dev-playbook` を直接submoduleとして追加しません。Platform自体もApplicationのsubmoduleにすることを基本とはせず、ワークスペース上の共有入口として配置します。

### 3. Project Contextを作る

Application側に `decisions/project-context.md` を用意し、対象ユーザー、認証、主対象デバイス、認可粒度等、実装前に固定すべき現在の前提を記録します。

新規導入・既存Applicationへの段階適用の詳細は [Adoption Guide](docs/adoption.md) を参照してください。

## ワークスペースの配置例

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

## 更新方法

Platform本体を更新した後、Platformが指しているsubmoduleの組合せへ同期します。

```bash
cd ai-dev-platform
git pull --ff-only
git submodule update --init --recursive
```

通常利用では、Application側からStandards / Playbookを個別に追従しません。どの組合せを利用するかはPlatformのsubmodule pointerを正とします。

同じ判断を再現する必要がある作業では、Platform自体をrelease tagまたはcommitで固定します。

## ui-platform との関係

`ui-platform` は本リポジトリのsubmoduleにはしません。独立したリポジトリとして維持します。

UIに関する責務は `ui-platform` に集約します。

- **Components**: 各Applicationが実際に利用する再利用可能なUI部品
- **Patterns**: 同じUX課題に対する設計候補と選択条件
- **Templates**: 複数Patternを組み合わせた画面レベルの構成例
- **Catalog / Storybook**: Component・Pattern・Templateを見て比較・検証する表示面

Application側ではUI Kitを `application-ui-kit` という固定の依存名で利用します。GitHub Packages上の実パッケージ名はpublish元に応じた `@<owner>/application-ui-kit` とし、利用側の `package.json` ではnpm aliasにより固定名へ割り当てます。package versionは対象Applicationの `package.json` / lockfileをSource of Truthとします。

ここでの用語は次のように区別します。

- **ui-platform**: UI設計・Component source・Pattern・Template・Catalogを所有するリポジトリ
- **application-ui-kit**: ui-platformがApplication向けに提供するpackageの利用名

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

Standardへの昇格は慎重にします。Recommendation、Playbook、ui-platform、Project側で十分であればStandardにしません。

## このリポジトリに置かないもの

- Standards本文のコピー（`standards/` submoduleを正とする）
- Playbook本文のコピー（`playbook/` submoduleを正とする）
- UI Component、UI Pattern、Template、Storybook（`ui-platform` の責務）
- 社員・組織・認証基盤などの業務ドメイン固有情報（各Applicationの責務）
- 新規Application用の巨大なボイラープレート
- AIエージェント定義、モデル設定、複雑なワークフロー実行基盤
