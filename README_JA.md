# holacracy-harness

**Claude Code向けの自己統治型エージェントチーム設計者。** Anchor Circle Purpose を宣言すれば、`harness` がそれに奉仕する Holacracy ロールを設計し、`governance` が Purpose の進化に合わせてロール集合を進化させます。Purpose 自体は憲法で保護されます。

[English](./README.md)

## これは何か

[`gh skill`](https://cli.github.com/manual/gh_skill_install) で配布される単一リポジトリのプラグイン。2つのスキルが同梱:

- **`harness`** (Layer 1) — Anchor Circle の articulation を facilitate し、ランタイム scaffold を書き出す
- **`governance`** (Layer 2) — 呼び出し統計に基づきロールを自律的に追加・更新・削除 (Anchor Circle Purpose で文脈づけ)

両方とも `gh skill update --all` で自動更新。

## インストール

```bash
# プロジェクトスコープ (このプロジェクトのみ)
gh skill install HikaruEgashira/holacracy-harness harness    --agent claude-code --scope project
gh skill install HikaruEgashira/holacracy-harness governance --agent claude-code --scope project

# または ユーザースコープ (全プロジェクト共通)
gh skill install HikaruEgashira/holacracy-harness harness    --agent claude-code --scope user
gh skill install HikaruEgashira/holacracy-harness governance --agent claude-code --scope user
```

リリースに固定: `@v0.1.0` を付加。

`gh` v2.90.0以降が必要。

## 使い方

git初期化済みでスキルをインストールしたプロジェクトで:

```bash
$ claude
> ハーネスを構成して
```

`harness`スキルがガイドします:

```
Phase 1: Anchor Circle Articulation (Purpose / Domains / Accountabilities)
Phase 2: ロールアーキテクチャ設計 (6レイアウトから選択)
Phase 3: Scaffoldインストール (CONSTITUTION.md, ANCHOR.md, hooks, tests)
Phase 4: ロールファイル生成 (.claude/agents/)
Phase 5: Anchor Circle Policies の追加
Phase 6: 検証 & スモークテスト
```

Phase 6完了後、プロジェクトは完全に配線されています:

```
your-project/
├── .claude/
│   ├── ANCHOR.md            # Anchor Circle Purpose (人間が著者)
│   ├── CONSTITUTION.md      # 12条の普遍条項 + Anchor Circle Policies
│   ├── settings.json        # 3つのhook配線
│   ├── agents/              # 生成された3-5ロール (governanceが進化させる)
│   ├── hooks/               # ロギング + 閾値チェック
│   └── state/               # stats.jsonl, prompts.jsonl, governance-log.jsonl
├── tests/governance-tests.sh
└── scripts/
    ├── init.sh
    └── update-scaffold.sh
```

以降は`governance`スキルが運用を引き継ぎます。SessionEnd hookが threshold-check を実行し、24時間クールダウン経過 + 閾値突破時に `governance auto-run` を自動起動。1回の実行で最大3変更、`governance/<UTC-date>` ブランチに反映。

Auto-run は **opt-in**。`GOVERNANCE_AUTO_RUN=1` を環境変数にセットしない限り、SessionEnd hookは threshold trip をログするだけで起動しません。リモートへの push はさらに `GOVERNANCE_AUTO_PUSH=1` でゲートされます。フラグ未設定時、governanceは無監督下で外部に影響を与えません。

## ロール配置レイアウト

Phase 2 の非規範的補助。Holacracy primitive ではない。

| レイアウト | Anchor Circle Purpose の性質 |
|---|---|
| Pipeline | 段階的・直線的 |
| Fan-out / Fan-in | 多角的 |
| Expert Pool | 多様で受動的 |
| Producer / Reviewer | 品質重視 |
| Supervisor | 動的・不確実 |
| Network | 探索的 |

## 更新

- **スキル** は `gh skill update --all` で自動更新。SKILL.mdのfrontmatterに provenance情報が書き込まれており、バージョン番号だけでなく実コンテンツのドリフトを検知。
- **Scaffold** (プロジェクト内のCONSTITUTION universal部・hooks・tests) は `./scripts/update-scaffold.sh` で更新。`.claude/agents/`, `.claude/state/`, `.claude/ANCHOR.md`, CONSTITUTIONのLOCAL部分は保持されます。

## 2層モデル

```
┌───────────────────────────────────────────┐
│  Layer 1: harness skill (gh skill)        │
│    初期ロール設計                            │
│    gh skill で自動更新                       │
└───────────────────────────────────────────┘
                  ↓ プロジェクトに scaffold + roles を書き込む
┌───────────────────────────────────────────┐
│  Layer 2: governance skill (gh skill)     │
│    統計ベースでロール進化                     │
│    gh skill で自動更新                       │
└───────────────────────────────────────────┘
```

Layer 1 はプロジェクトごとに1回 (または必要時)。Layer 2 は以降継続的に動作、編集可能な憲法に縛られて。

## ライセンス

Apache-2.0
