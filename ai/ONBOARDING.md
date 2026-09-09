# AI エージェント オンボーディング

> AI agentがApplicationへ参加するときの **唯一の共有開発資産入口** です。
> 最初にこのfileを読み、Taskに必要な資産だけへ進みます。

## 必守事項

1. **共有documentを最初から全量読まない。** Taskに必要なCore Standardだけを読み、Optional Standard / Recommendation / Playbookは該当する場合だけ読む。
2. **行動規範は [Governance Standard](../standards/standards/governance/) に従う。** AI利用、Git操作、Standard逸脱の記録、必須の機械的gateはすべてのTaskに適用するCore Standardであり、このfileへ再掲しない。
3. **新しいlibrary / packageを追加する前に [Recommendations](../recommendations/) を確認する。** 未収録のものは [Recommendations README](../recommendations/README.md) の健全性チェックを行い、結果を短く提示してから採用する。
4. **実装へ大きく影響する場合、対象Applicationの `decisions/project-context.md` を先に読む。** 対象user、認証、device、認可等を勝手に仮定しない。

---

## Router

### 1. 判断・制約 → Standards

👉 [Standards](../standards/)

- [Governance](../standards/standards/governance/) — AI利用、Git、Standard逸脱、機械的gate。すべてのTaskで読む
- [Architecture](../standards/standards/architecture/) — Django、PostgreSQL、認証・認可、Security、Logging、Testing、container boundary
  - React / TypeScriptを扱う場合: [TypeScript Standard](../standards/standards/architecture/typescript.md)
- [Application UI](../standards/standards/application-ui/) — UI constraint、Layout Profile、Semantic Token、feedback、Form UX

Optional Standardは該当機能を扱う場合だけ参照する。

### 2. Current library / tool choice → Recommendations

👉 [Recommendations](../recommendations/)

新規採用・依存変更時に参照する。Standardより拘束力は弱く、逸脱にADRは要求しない。

主な対象:

- Frontend library
- Runtime validation
- Toolchain
- Quality recommendation

### 3. UI design / implementation → UI Platform

👉 [ui-platform](https://github.com/hamirilo/ui-platform)

UI Platformが所有するもの:

- Foundations
- Components
- Patterns
- Templates
- Catalog / Storybook
- AI / 人間向けdesign reference

UI Taskでは次の順で確認する。

1. 対象Applicationが `application-ui-kit` を依存として利用しているか確認する。
2. 利用している場合はApplicationの `package.json` / lockfileからversionを確認し、新しいUIを作る前に既存Component / Pattern / Templateを確認する。既存Componentで解決できる場合は再実装しない。
3. 利用していない場合もPattern / Template / Catalogはdesign referenceとして参照できるが、既存Componentがあることだけを理由にUI Kitを追加しない。
4. UX上の選択はPattern、画面構成はTemplate、実際の状態・操作はStorybook Catalogを参照する。
5. `application-ui-kit` を利用しているApplicationでは、見せ方だけの切替（tab、開閉、出し分け）とtemplate用の共通classはApplication側で重複実装せず、UI Platformが提供するものを優先する。Django TemplateへIsland / htmxを接続・追加する手順はPlaybookの [DjangoとReact Islandsの接続](../playbook/playbooks/django-react-islands.md) に従う。利用していないApplicationには3.が優先し、この項目を理由にUI Kitを追加しない。

GitHub Packages上の実package名は `@<owner>/application-ui-kit`、Application codeからの依存名はnpm aliasで `application-ui-kit` に固定する。

Package versionのSource of Truthは対象Applicationの `package.json` / lockfileであり、UI Platformのmain branchではない。

業務domain固有UIはdomainを所有するprojectで管理する。

### 4. Implementation / migration / verification / recovery → Playbook

👉 [Playbook](../playbook/)

具体例、command、checklist、troubleshootingはTaskに必要なPlaybookだけを参照する。

---

## 品質

- 必須gate（Type Check、Linter、Production Build、基本Test）の扱いは [Governance Standard](../standards/standards/governance/) の「必須の機械的検証」に従う。
- Performance、Accessibility、実browser操作性等の目標は [Quality Recommendations](../recommendations/quality.md)、測定・確認の手順は [品質確認Playbook](../playbook/playbooks/quality-checks.md) を参照する。

---

## 新しい共有資産を追加するとき

配置先の判断は [ADR-0003](../standards/decisions/adr-0003-core-and-optional-standards.md) と [ADR-0006](../standards/decisions/adr-0006-platform-composition-boundary.md) を正とする。

```text
守る判断・制約                    -> Standards
current library / tool choice     -> Recommendations
implementation / verification     -> Playbook
UI design / implementation        -> UI Platform
project固有                       -> Project Context / ADR / code
```

同じ内容を複数layerへcopyしない。
