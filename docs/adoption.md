# Adoption Guide

`ai-dev-platform` を新しいApplicationへ導入するとき、または既存Applicationへ段階的に適用するときの手順です。

この文書は **Platformの導入・適用方法** を扱います。個々のruleの正本は `standards/`、implementation / migration / verificationの詳細は `playbook/`、current library choiceは `recommendations/` です。

## 1. Platformをworkspaceへ配置する

ApplicationごとにStandards / Playbookをsubmoduleとして組み込まず、複数Applicationから参照できる位置へPlatformを1つ配置します。

```text
workspace/
├── ai-dev-platform/
├── ui-platform/
├── application-a/
└── application-b/
```

初回cloneではsubmoduleも同時に取得します。clone先のrepository URLを変数へ設定してから実行します。

```bash
AI_DEV_PLATFORM_REPOSITORY_URL="https://github.com/your-owner/ai-dev-platform.git"
git clone --recurse-submodules "$AI_DEV_PLATFORM_REPOSITORY_URL"
```

通常のcloneを行った場合は後から初期化します。

```bash
cd ai-dev-platform
git submodule update --init --recursive
```

`standards/` と `playbook/` が取得されていることを確認します。

Platformの `.gitmodules` はowner-relative URLを利用します。forkを利用するownerは、同じowner配下に `ai-dev-standards` / `ai-dev-playbook` も用意します。

## 2. Applicationから唯一のAI入口を参照する

各Applicationの `CLAUDE.md` 等からPlatform側の `ai/ONBOARDING.md` を参照させます。

```markdown
開発Standard・Recommendations・Playbookは
../ai-dev-platform/ai/ONBOARDING.md
を最初に参照すること。
```

実際のrelative pathはworkspace構成に合わせます。

Applicationから個別資産を直接AIの入口にしません。

- `ai-dev-standards` のREADME
- `ai-dev-playbook` のREADME
- `recommendations/` の個別file

AIはPlatform ONBOARDINGからTaskに必要な資産だけへ進みます。

## 3. Project Contextを用意する

Application直下に `decisions/project-context.md` を用意し、AIが実装前に確認すべき **現在の前提** を記録します。

最低限、実装へ大きく影響する次を決めます。

| 項目 | 確認すること |
|---|---|
| 対象user / 認証 | Loginが必要か。社内、一般、その両方のどれか |
| User識別 | emailを前提にできるか、employee ID等の内部IDか |
| 主対象device | PC / tablet / mobileのどれを優先するか |
| UI Layout | Standard App / Simple App / Focus Appのどれを起点にするか |
| 認可粒度 | 業務権限をどの単位で分けるか |

該当しない項目は「該当なし」と記録します。

Project Contextはfeature requirement、schedule、team情報の集約場所にはしません。未決定だとAIが仮定を置き、大きな手戻りにつながる前提だけを持たせます。

現在の前提を更新したとき、変更理由自体を将来説明する価値がある場合だけ別の連番ADRを残します。

## 4. Core Standardを確認する

Platform ONBOARDINGを入口として、Taskに必要なCore Standardを確認します。

| 項目 | 正本 |
|---|---|
| Project側ADR、AI利用、Git、機械的検証 | `standards/standards/governance/` |
| Django / PostgreSQL / 認証 / 認可 / Logging / Testing | `standards/standards/architecture/` |
| shadcn/ui / Layout / Semantic Token / UI constraints | `standards/standards/application-ui/` |
| Current library / toolchain default | `recommendations/` |

Optional Standardは先回りして全量を読まず、該当機能を扱う場合だけ参照します。

## 5. 新規Applicationで用意するもの

次は初期確認listです。ruleそのものはここへ複製しません。

- `CLAUDE.md` 等からPlatform ONBOARDINGを参照する
- `decisions/project-context.md` を用意する
- Python dependency managementをStandardに合わせる
- lockfileをGitへcommitする
- JS package manager / lockfileをrepository内で混在させない
- Formatter / Linterを導入し、利用可能ならType Checkerも利用する
- Database、認証、UI基盤等についてCore Standardとの差分を確認する
- Production運用前にLogging Standardを満たす

具体的なsetup commandやimplementation手順はPlaybookまたはApplication側の開発手順で扱います。

## 6. 既存Applicationへ適用する場合

既存ApplicationではStandardとの違いだけを理由に全面migrationしません。

最初に次を行います。

1. Platform ONBOARDINGへの参照を追加する。
2. `decisions/project-context.md` を用意する。
3. 現在の実装とCore Standardとの差分を把握する。

差分は次の3種類に分けます。

- **Required**: 今回の変更箇所でStandardに反するもの、またはsecurity、data integrity、必須CI gate等の現在の問題
- **Adopt going forward**: 既存方式は維持し、新規・変更箇所からStandardへ寄せるもの
- **Optional improvement**: 品質向上、近代化、追加機能等。Standard適合とは分離するもの

具体的なmigrationが必要な場合は該当Playbookを参照します。

## 7. Platformを更新する

mainの最新Platformへ追従し、そのcommitがpinするStandards / Playbookへ同期します。

```bash
cd ai-dev-platform
git switch main
git pull --ff-only
git submodule update --init --recursive
```

Application側からStandards / Playbookを個別にlatestへ進めません。**利用する組合せはPlatformのsubmodule pointerを正**とします。

Platformをrelease tagまたはcommitへ固定している場合はmainへ切り替えず、その固定commitが指すsubmoduleを利用します。

## 完了条件

- Platformとsubmoduleが取得されている
- ApplicationのAI設定がPlatform ONBOARDINGを入口としている
- `decisions/project-context.md` に実装へ大きく影響する前提が記録されている
- Core Standardとの差分を把握できている
- 既存Applicationの場合、Required / Adopt going forward / Optional improvementを区別できている
