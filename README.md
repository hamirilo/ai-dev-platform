# AI Development Platform

開発時に「何を守るか・何を選ぶか・どう実施するか」へ適切にルーティングする **統合入口（composition root）** です。

Platformへすべての知識・実装を集約せず、責務ごとに分離した資産をApplicationから一貫した入口で利用できるようにします。

## 構成

```text
ai-dev-platform/
├── ai/
│   └── ONBOARDING.md       AI agentが最初に読む唯一の入口
├── docs/
│   └── adoption.md         Platformの導入・Applicationへの適用
├── recommendations/        現時点の選択の正本
├── standards/              [submodule: ai-dev-standards]
└── playbook/               [submodule: ai-dev-playbook]
```

UIの具体的なdesign・実装資産は独立した [ui-platform](https://github.com/hamirilo/ui-platform) が所有します。

## 各領域の役割

| 領域 | 問い | 正本 |
|---|---|---|
| Standards | 何を守る？ | `standards/` |
| Recommendations | 普段は何を選ぶ？ | `recommendations/` |
| Playbook | どう実装・移行・検証・復旧する？ | `playbook/` |
| UI Platform | UIをどう設計・実装する？ | `ui-platform` |
| Project Context / ADR | このApplication固有ではどうする？ | 各Application |

同じ内容を複数箇所へcopyしません。Platformは **入口、routing、Recommendations、Standards / Playbookの組合せ** を担当します。

## Quick Start

### 1. Platformをcloneする

```bash
git clone --recurse-submodules <ai-dev-platform-repository-url>
```

通常のcloneを行った場合は後からsubmoduleを初期化します。

```bash
cd ai-dev-platform
git submodule update --init --recursive
```

`.gitmodules` はowner-relative URLを利用します。forkで利用する場合は、同じowner配下に `ai-dev-standards` と `ai-dev-playbook` も用意します。これによりforkごとにsubmodule URLを書き換える差分を持ちません。

### 2. ApplicationからPlatform ONBOARDINGを参照する

各Applicationの `CLAUDE.md` 等には、Platform側の `ai/ONBOARDING.md` を最初に読むよう記載します。

```markdown
開発Standard・Recommendations・Playbookは
../ai-dev-platform/ai/ONBOARDING.md
を最初に参照すること。
```

実際のrelative pathはworkspace構成に合わせます。

Applicationへ `ai-dev-standards` / `ai-dev-playbook` を直接submoduleとして追加しません。PlatformもApplicationへ埋め込まず、workspace上の共有入口として配置することを基本とします。

### 3. Project Contextを用意する

Application側に `decisions/project-context.md` を用意し、対象user、認証、主対象device、認可粒度等、実装へ大きく影響する現在の前提を記録します。

詳細は [Adoption Guide](docs/adoption.md) を参照してください。

## Workspace例

```text
workspace/
├── ai-dev-platform/
│   ├── standards/
│   ├── playbook/
│   └── recommendations/
├── ui-platform/
├── application-a/
└── application-b/
```

## 更新方法

mainの最新Platformへ追従する場合は、Platform自身を更新してから、そのcommitがpinするsubmoduleへ同期します。

```bash
cd ai-dev-platform
git switch main
git pull --ff-only
git submodule update --init --recursive
```

Standards / PlaybookをApplication側から個別にlatestへ進めません。**どの組合せを利用するかはPlatformのsubmodule pointerを正**とします。

再現性が必要な場合はPlatform自体をrelease tagまたはcommitで固定し、そのcommitが指すsubmoduleを利用します。

## UI Platformとの関係

`ui-platform` はPlatformのsubmoduleにはしません。UIのrelease cycleとApplicationごとのpackage採用versionがStandards / Playbookとは異なるためです。

UI Platformが所有するもの:

- Foundations
- Components
- Patterns
- Templates
- Catalog / Storybook
- AI / 人間向けdesign reference

Application側でUI packageを利用する場合、依存名は `application-ui-kit` に固定します。GitHub Packages上の実package名は `@<owner>/application-ui-kit` とし、npm aliasでowner差分を利用側設定へ閉じ込めます。

Package versionのSource of Truthは対象Applicationの `package.json` / lockfileです。

## 知識・資産の成熟

```text
Project固有の判断・実装
        ↓
複数回利用して有効だった
        ↓
Recommendation / Playbook
        ↓
UIとして再利用するなら UI Platform
        ↓
不一致そのものが実害になる
        ↓
必要な場合のみ Standard
```

最初からすべてをStandardや共有資産へ昇格させません。

## このrepositoryに置かないもの

- Standards本文のcopy
- Playbook本文のcopy
- UI Component / Pattern / Template / Storybook
- 業務domain固有情報
- Application固有の機能要件・運用手順
- 巨大なboilerplate
- AI agent定義、model設定、workflow実行基盤
