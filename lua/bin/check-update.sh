#!/usr/bin/env bash

# Check if we are in detached HEAD state
if [ $(git rev-parse --abbrev-ref --symbolic-full-name HEAD) = 'HEAD' ]; then
  exit 0
fi

# Fetch updates from remote (ensure we have latest information)
echo "Fetching..."
git fetch origin >/dev/null 2>&1 || true

# Get the upstream branch for the current branch
upstream_branch=$(git branch --show-current | sed 's/\*\s*//')

# Check if there is an upstream branch
if [ -z "$upstream_branch" ]; then
    echo "no upstream branch"
  exit 0
fi

local_hash=$(git rev-parse HEAD)
remote_hash=$(git rev-parse origin/$upstream_branch)
if ! git merge-base --is-ancestor $remote_hash HEAD; then
    echo "local running behind origin"
  exit 1
fi

echo "up to date"
exit 0
