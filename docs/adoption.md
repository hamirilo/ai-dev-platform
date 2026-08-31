# Adoption Guide

`ai-dev-platform` を新しいApplicationへ導入するとき、または既存Applicationへ段階的に適用するときの手順です。

この文書は **Platformの導入・適用方法** を扱います。個々のルールの正本は `standards/`、実装・移行・検証の詳細手順は `playbook/`、ライブラリ選定は `recommendations/` です。

## 1. Platformをワークスペースへ配置する

ApplicationごとにStandards / Playbookをsubmoduleとして組み込まず、複数Applicationから参照できる位置へPlatformを1つ配置します。

```text
workspace/
├── ai-dev-platform/
├── ui-platform/
├── application-a/
└── application-b/
```

初回cloneではsubmoduleも同時に取得します。

```bash
git clone --recurse-submodules git@github.com:hamirilo/ai-dev-platform.git
```

通常のcloneを行った場合は、後から初期化できます。

```bash
cd ai-dev-platform
git submodule update --init --recursive
```

`standards/` と `playbook/` が取得されていることを確認します。

## 2. Applicationから唯一のAI入口を参照する

各Applicationの `CLAUDE.md` 等のAI設定ファイルから、Platform側の `ai/ONBOARDING.md` を参照させます。

```markdown
開発Standard・Recommendations・Playbookは
../ai-dev-platform/ai/ONBOARDING.md
を最初に参照すること。
```

実際の相対パスはワークスペース構成に合わせます。

Applicationから次を直接入口にしません。

- `ai-dev-standards` のREADMEや旧ONBOARDING
- `ai-dev-playbook` のREADME
- `recommendations/` の個別ファイル

AIはPlatformのONBOARDINGからタスクに必要な資産だけへ進みます。

## 3. Project Contextを用意する

Application直下に `decisions/` を用意し、現在のプロジェクト前提を `decisions/project-context.md` に記録します。

これは連番ADRではありません。AIが実装前に確認する **現在の前提** です。

最低限、実装へ大きく影響する次の事項を決めます。

| 項目 | 確認すること |
|---|---|
| 対象ユーザー / 認証 | ログインが必要か。社内従業員、一般ユーザー、その両方のどれか |
| ユーザー識別 | メールアドレスを前提にできるか、社員番号等の内部IDか |
| 主対象デバイス | PC / タブレット / モバイルのどれを優先するか |
| UI Layout | Standard App / Simple App / Focus App のどれを起点にするか |
| 認可粒度 | 業務権限をどの単位で分けるか |

該当しない項目は「該当なし」と記録します。

項目を増やすのは、**未決定のままだとAIが実装中に仮定を置き、その仮定が覆ったときの手戻りが大きいもの**に限定します。機能要件、スケジュール、体制をここへ集約しません。

前提を変更した場合は `project-context.md` を更新し、変更理由を将来説明する価値がある場合だけ別の連番ADRを残します。

## 4. Standardの初期確認

Project Contextを用意した後、PlatformのONBOARDINGを入口として必要なCore Standardを確認します。

新規Applicationでは、少なくとも次の判断が必要か確認します。

| 項目 | 正本 |
|---|---|
| Project側ADRの扱い、AI利用、Git、機械的検証 | `standards/standards/governance/` |
| Django / PostgreSQL / 認証 / 認可 / Logging / Testing | `standards/standards/architecture/` |
| shadcn/ui / Tailwind / Layout / Semantic Token | `standards/standards/application-ui/` |
| 現時点のライブラリ・toolchain既定 | `recommendations/` |

Optional Standardは先回りして全部読みません。該当機能を扱う場合だけ参照します。

## 5. 新規Applicationで用意するもの

次は、既存Standardで決まっている事項の確認リストです。ルールそのものはこの文書へ再掲せず、正本を参照します。

- `CLAUDE.md` 等からPlatform ONBOARDINGを参照する
- `decisions/project-context.md` を用意する
- Pythonの環境・依存管理をStandardに合わせる
- lockfileをGitへcommitする
- JS側でpackage manager / lockfileを混在させない
- Formatter / Linterを導入し、利用可能ならType Checkerも利用する
- Database、認証、UI基盤等についてCore Standardとの差分を確認する
- 本番運用を始めるまでにLogging Standardを満たす

具体的な設定方法やコマンドはStandardへ追加せず、該当するPlaybookまたはApplication側の開発手順で扱います。

## 6. 既存Applicationへ適用する場合

既存Applicationでは、一度に全面移行しません。

最初に次だけを行います。

1. Platform ONBOARDINGへの参照を追加する。
2. `decisions/project-context.md` を用意する。
3. 現在の実装とCore Standardとの差分を把握する。

差分は次の3種類に分けます。

- **Required**: 今回の変更箇所でStandardに反するもの、またはセキュリティ、データ整合性、必須CIゲート等の現在の問題
- **Adopt going forward**: 既存方式は維持し、新規・変更箇所からStandardへ寄せるもの
- **Optional improvement**: 品質向上、近代化、追加機能。Standard適合とは分離するもの

Standardとの違いだけを理由に、依存ライブラリの一括置換、全面リファクタリング、インフラ更新を要求しません。

具体的な移行作業が必要になった場合は、該当するPlaybookを参照します。

## 7. Platformを更新する

Platform本体を更新した後、mainが指しているStandards / Playbookの組合せへsubmoduleを同期します。

```bash
cd ai-dev-platform
git pull --ff-only
git submodule update --init --recursive
```

通常のApplication開発では、Standards / PlaybookのsubmoduleをApplication側から個別に追従させません。**どの組合せを利用するかはPlatformのsubmodule pointerを正**とします。

再現性が必要な作業では、Platform自体をrelease tagまたはcommitで固定します。

## 完了条件

初回導入は、次を満たせば完了です。

- Platformとsubmoduleが取得されている
- ApplicationのAI設定がPlatform ONBOARDINGを入口としている
- `decisions/project-context.md` があり、実装へ大きく影響する前提が記録されている
- Core Standardとの差分を把握できている
- 既存Applicationの場合、一括移行せずRequired / Adopt going forward / Optional improvementを区別できている
