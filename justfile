set shell := ["bash", "-c"]

# デフォルトタスク
default:
	@just --list

# ドキュメントのリンク切れチェック (lychee を使用)。submoduleを初期化してから実行する
check-docs:
	@echo "Running document link checks..."
	lychee "./**/*.md" --exclude-path standards --exclude-path playbook --offline --no-progress
