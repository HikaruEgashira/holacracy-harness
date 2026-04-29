# holacracy-harness

**Claude Code向けの自己統治型エージェントチーム設計者。** `gh skill`でインストール可能な2つのスキルが、Holacracy的なエージェントチームを設計し、その後継続的に進化させます。

[English](./README.md)

## これは何か

[`gh skill`](https://cli.github.com/manual/gh_skill_install) で配布される単一リポジトリのプラグイン。2つのスキルが同梱:

- **`harness`** (Layer 1) — 初期のロールアーキテクチャを設計し、ランタイムscaffoldを書き出す
- **`governance`** (Layer 2) — 呼び出し統計に基づきロールを自律的に追加・更新・削除

両方とも `gh skill update --all` で自動更新。

## インストール

```bash
# プロジェクトスコープ (このプロジェクトのみ)
gh skill install plenoai/holacracy-harness harness    --agent claude-code --scope project
gh skill install plenoai/holacracy-harness governance --agent claude-code --scope project

# または ユーザースコープ (全プロジェクト共通)
gh skill install plenoai/holacracy-harness harness    --agent claude-code --scope user
gh skill install plenoai/holacracy-harness governance --agent claude-code --scope user
```

リリースに固定: `@v0.1.0` を付加。

`gh` v2.90.0以降が必要。

## 使い方

git初期化済みでスキルをインストールしたプロジェクトで:

```bash
$ claude
> ハーネスを構成して。<ドメイン記述>
```

`harness`スキルがガイドします:

```
Phase 1: ドメイン分析
Phase 2: ロールアーキテクチャ設計 (6パターンから選択)
Phase 3: Scaffoldインストール (CONSTITUTION.md, hooks, tests)
Phase 4: ロールファイル生成 (.claude/agents/)
Phase 5: ドメイン固有の憲法条項追加
Phase 6: 検証 & スモークテスト
```

Phase 6完了後、プロジェクトは完全に配線されています:

```
your-project/
├── .claude/
│   ├── CONSTITUTION.md      # 10条の普遍条項 + ローカル条項
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

## アーキテクチャパターン

| パターン | 適用場面 |
|---|---|
| Pipeline | 段階的な直線作業 |
| Fan-out / Fan-in | 多角的調査 |
| Expert Pool | 多様で受動的な要求 |
| Producer / Reviewer | 品質重視 |
| Supervisor | 動的・計画駆動 |
| Network | 探索的 |

## 更新

- **スキル** は `gh skill update --all` で自動更新。SKILL.mdのfrontmatterに provenance情報が書き込まれており、バージョン番号だけでなく実コンテンツのドリフトを検知。
- **Scaffold** (プロジェクト内のCONSTITUTION universal部・hooks・tests) は `./scripts/update-scaffold.sh` で更新。`.claude/agents/`, `.claude/state/`, CONSTITUTIONのLOCAL部分は保持されます。

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
