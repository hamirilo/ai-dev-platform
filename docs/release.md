# リリース方針

この文書は、`ai-dev-platform`、`ai-dev-standards`、`ai-dev-playbook`、`ui-platform`のversionとreleaseの関係を定めます。各リポジトリ固有の実行方法は、そのリポジトリのREADMEまたはworkflowを正とします。

## 正式なrelease

- 各リポジトリの正式なreleaseは、SemVer形式のtag（`v<major>.<minor>.<patch>`）を伴うGitHub Releaseとする。
- npm package releaseは例外とし、`application-ui-kit-v<package-version>`形式のtagを使用する。
- tagだけを単独で作らず、変更点と必要な移行事項をRelease notesへ記載する。
- `main`は次のrelease候補であり、再現可能な採用versionとしてはrelease tagまたはcommitを指定する。
- すべてのmergeでreleaseする必要はない。関連する変更をまとめてreleaseしてよい。

## SemVerの判断

| 種別 | 判断 | 例 |
|---|---|---|
| PATCH | 既存方針と互換性を保つ修正・明確化 | 誤記修正、説明補足、手順の訂正 |
| MINOR | 既存利用者を壊さない追加 | Standard / Recommendation / Playbookの追加、新しい任意の選択肢 |
| MAJOR | 採用側の判断や実装変更が必要な変更 | 既存方針の削除・反転、必須事項の破壊的変更、共有資産の責務境界変更 |

迷う場合は、変更量ではなく**既存利用者が現在の採用方法を変える必要があるか**で判断します。

## Platformが固定する組合せ

`ai-dev-standards`と`ai-dev-playbook`は独立してreleaseできますが、個別のreleaseだけではPlatform利用者の組合せは変わりません。

`ai-dev-platform`のsubmodule pointerを更新してPlatformをreleaseした時点で、推奨するStandards / Playbookの組合せが確定します。Applicationは個別submoduleをlatestへ進めず、採用したPlatform tagまたはcommitが指す組合せを利用します。

## リリース順序

StandardsまたはPlaybookの変更をPlatformへ採用する場合は、次の順序で進めます。

1. 変更元リポジトリのPRをrelease候補として準備する。
2. PRのhead commitを基準に、関係するStandards / Playbook間の矛盾がないことをrelease前に確認する。
3. 確認済みのPRをmergeし、必要なversionで変更元リポジトリをreleaseする。
4. Platformでsubmodule pointerをrelease済みcommitへ更新する。
5. PlatformのRelease notesに、採用した各versionと主要な変更を記載する。
6. Platformをreleaseする。

StandardsとPlaybookの両方に変更がある場合は、原則としてStandards、Playbook、Platformの順にreleaseします。Playbookが新しいStandardを前提としない独立変更であれば、Standardsのreleaseは不要です。

## リポジトリごとの方法

| リポジトリ | release方法 | 備考 |
|---|---|---|
| `ai-dev-standards` | Release Please | release PRのversionと`CHANGELOG.md`を確認してmergeする |
| `ai-dev-playbook` | Release Please | release PRのversionと`CHANGELOG.md`を確認してmergeする |
| `ai-dev-platform` | 手動GitHub Release | submoduleの組合せとRecommendationsをreleaseする |
| `ui-platform` | リポジトリとnpm packageを個別にrelease | 詳細は`ui-platform` READMEを正とする |

release手段を揃えること自体を目的に自動化を増やしません。反復負荷や誤操作が実際に問題になった時点で、PlatformへのRelease Please導入を検討します。

## UI Platform

`ui-platform`はPlatformのsubmoduleではなく、独立したrelease cycleを持ちます。

- `v<version>`: UI Platformリポジトリのrelease
- `application-ui-kit-v<package-version>`: npm packageのrelease

Applicationが利用するpackage versionのSource of Truthは、そのApplicationの`package.json`とlockfileです。Platform releaseへUI packageを同梱したり、Platformと同じversionへ揃えたりしません。

## Release notesの最小項目

PlatformのRelease notesには、少なくとも次を記載します。

- 採用した`ai-dev-standards` version
- 採用した`ai-dev-playbook` version
- Recommendationsの主な変更
- 既存Applicationで対応が必要な変更の有無

対応が不要な場合も「移行作業なし」と明記します。
