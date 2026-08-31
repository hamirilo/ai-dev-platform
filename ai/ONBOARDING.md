# AI エージェント オンボーディング

> AI agentがApplicationへ参加するときの **唯一の共有開発資産入口** です。
> 最初にこのfileを読み、Taskに必要な資産だけへ進みます。

## 必守事項

1. **既存Standardを確認してから新しい判断を行う。**
2. **既存実装を確認し、同じ用途を理由なく再実装しない。** UI Taskでは採用済みUI packageとUI Platformを確認する。
3. **共有documentを最初から全量読まない。** Taskに必要なCore Standardだけを読み、Optional Standard / Recommendation / Playbookは該当する場合だけ読む。
4. Standardから重要な逸脱をする場合はProject側ADR等に理由を残す。
5. 「将来使うかもしれない」という理由だけでStandard、共通layer、Component、Patternを増やさない。
6. 新しいlibrary / packageを追加する前に [Recommendations](../recommendations/) を確認する。未収録のものはmaintainability / security / ecosystem等を短く確認してから採用する。
7. 実装へ大きく影響する場合、対象Applicationの `decisions/project-context.md` を先に読む。対象user、認証、device、認可等を勝手に仮定しない。
8. **具体的なimplementation / migration / verification手順をStandardへ追加しない。** 判断・制約はStandards、手順はPlaybook、UIの具体的design / implementationはUI Platformへ置く。
9. 対象projectで定義されているType Check、Linter、Build、基本Testを通す。該当する場合はPR / merge / releaseの必須gateとする。

---

## Router

### 1. 判断・制約 → Standards

👉 [Standards](../standards/)

- [Governance](../standards/standards/governance/) — AI利用、Git、Standard逸脱、機械的gate
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
2. 利用している場合はApplicationの `package.json` / lockfileからversionを確認する。
3. 新しいUIを作る前に既存Component / Pattern / Templateを確認する。
4. UX上の選択はPattern、画面構成はTemplate、実際の状態・操作はStorybook Catalogを参照する。
5. 既存Componentで解決できる場合は再実装しない。

GitHub Packages上の実package名は `@<owner>/application-ui-kit`、Application codeからの依存名はnpm aliasで `application-ui-kit` に固定する。

Package versionのSource of Truthは対象Applicationの `package.json` / lockfileであり、UI Platformのmain branchではない。

業務domain固有UIはdomainを所有するprojectで管理する。

### 4. Implementation / migration / verification / recovery → Playbook

👉 [Playbook](../playbook/)

具体例、command、checklist、troubleshootingはTaskに必要なPlaybookだけを参照する。

---

## 必須gateと品質推奨

### 必須gate

対象projectに存在する次の機械的検証は、該当する場合に必須gateとする。

- Type Check
- Linter
- Production Build
- 基本Test

errorを抑制して成功扱いにせず、原因側を修正する。

### 品質推奨

Performance、Accessibility、実browser操作性等は [Quality Recommendations](../recommendations/quality.md) を参照する。

具体的な測定・実browser確認は [Playbook](../playbook/) の品質確認・test/review手順を利用する。

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
