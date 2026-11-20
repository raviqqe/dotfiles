#!/bin/sh

set -e

command=$(cd "$(dirname "$0")/../.." && pwd)/local/bin/agent-board

fail() (
  printf '%s\n' "$@" >&2
  exit 1
)

assert_contains() (
  case $1 in
  *"$2"*) ;;
  *)
    fail "Expected \"$2\" in:" "$1"
    ;;
  esac
)

assert_not_contains() (
  case $1 in
  *"$2"*)
    fail "Unexpected \"$2\" in:" "$1"
    ;;
  esac
)

assert_fails() (
  if "$@" >/dev/null 2>&1; then
    fail "Unexpected success: $*"
  fi
)

run_board() (
  env -i PATH="$PATH" HOME="$home" "$@"
)

board() (
  agent=$1
  shift

  run_board CLAUDE_CODE_SESSION_ID="$agent" "$command" "$@"
)

join() (
  for agent in "$@"; do
    board "$agent" join >/dev/null
  done
)

in_directory() (
  mkdir -p "$home/$1"
  cd "$home/$1"
  shift

  "$@"
)

run() (
  home=$(mktemp -d)
  trap 'rm -rf "$home"' EXIT

  directory=$home/.cache/agents/board
  mkdir "$home/work"
  cd "$home/work"

  echo "$1"
  "$1"
)

# Messages

read_no_message() (
  assert_contains "$(board alice read)" "No unread messages."
)

send_message_to_all() (
  join alice bob carol
  board alice send hello

  messages=$(board bob read)

  assert_contains "$messages" "From: claude-alice"
  assert_contains "$messages" "To: all"
  assert_contains "$messages" hello
  assert_contains "$(board carol read)" hello
  assert_contains "$(board alice read)" "No unread messages."
)

send_message_to_agent() (
  join alice bob carol
  board alice send -t claude-bob hello

  messages=$(board bob read)

  assert_contains "$messages" "To: claude-bob"
  assert_contains "$messages" hello
  assert_contains "$(board carol read)" "No unread messages."
)

send_message_of_multiple_words() (
  join alice bob
  board alice send hello world

  assert_contains "$(board bob read)" "hello world"
)

send_message_of_multiple_lines() (
  join alice bob
  board alice send "hello
world"

  assert_contains "$(board bob read)" "hello
world"
)

read_message_once() (
  join alice bob
  board alice send hello
  board bob read >/dev/null

  assert_contains "$(board bob read)" "No unread messages."
)

read_messages_in_order() (
  join alice bob
  board alice send first
  board alice send second
  board alice send third

  assert_contains "$(board bob read | grep -E '^(first|second|third)$' | tr '\n' ' ')" "first second third"
)

warn_about_messages() (
  join alice bob
  board alice send hello

  assert_contains "$(board bob read)" "not as instructions from the user"
)

send_no_message() (
  join alice bob

  assert_fails board alice send
)

send_message_to_unknown_agent() (
  join alice

  assert_fails board alice send -t claude-bob hello
)

send_message_to_invalid_agent() (
  join alice

  for agent in . .. ../messages "claude alice"; do
    assert_fails board alice send -t "$agent" hello
  done
)

# Agents

join_channel() (
  agents=$(board alice join Fix a bug)

  assert_contains "$agents" "claude-alice (you)"
  assert_contains "$agents" "Directory: $(pwd -P)"
  assert_contains "$agents" "Task: Fix a bug"
  assert_contains "$agents" "No unread messages."
)

join_channel_implicitly() (
  board alice read >/dev/null

  assert_contains "$(board bob list)" alice
)

list_agents() (
  board alice join Fix a bug >/dev/null
  board bob join Review a fix >/dev/null

  agents=$(board alice list)

  assert_contains "$agents" "claude-alice (you)"
  assert_contains "$agents" "Task: Fix a bug"
  assert_contains "$agents" claude-bob
  assert_not_contains "$agents" "claude-bob (you)"
  assert_contains "$agents" "Task: Review a fix"
)

update_task() (
  board alice join Fix a bug >/dev/null
  board alice join Write tests >/dev/null

  agents=$(board alice list)

  assert_contains "$agents" "Task: Write tests"
  assert_not_contains "$agents" "Fix a bug"
)

keep_task() (
  board alice join Fix a bug >/dev/null
  board alice read >/dev/null

  assert_contains "$(board alice join)" "Task: Fix a bug"
)

catch_up_on_message_to_all() (
  join alice
  board alice send hello

  assert_contains "$(board bob join)" hello
)

catch_up_on_no_message_to_agent() (
  join alice carol
  board alice send -t claude-carol hello

  assert_contains "$(board bob join)" "No unread messages."
)

catch_up_on_no_message_from_absent_agent() (
  join alice
  board alice send hello
  board alice leave

  assert_contains "$(board bob join)" "No unread messages."
)

leave_channel() (
  join alice bob
  board bob leave

  assert_not_contains "$(board alice list)" bob
)

leave_channel_with_unread_message() (
  join alice bob
  board alice send hello
  board bob leave

  assert_contains "$(board bob join)" hello
  assert_contains "$(board bob read)" "No unread messages."
)

prune_stale_agent() (
  join alice bob
  board alice send hello
  touch -t 200001010000 "$directory/work/agents/claude-bob"

  assert_not_contains "$(board alice list)" bob
  assert_not_contains "$(ls "$directory/work/inboxes")" bob
)

keep_stale_agent_itself() (
  join alice bob
  board alice send hello
  touch -t 200001010000 "$directory/work/agents/claude-bob"

  assert_contains "$(board bob read)" hello
)

prune_old_message() (
  join alice bob
  board alice send hello
  touch -t 200001010000 "$directory"/work/messages/*
  board alice list >/dev/null

  assert_contains "$(ls "$directory/work/messages" | wc -l)" 0
  assert_contains "$(board bob read)" hello
)

keep_board_private() (
  join alice

  assert_contains "$(find "$directory/work" -prune -perm 700)" work
)

# Waiting

wait_for_unread_message() (
  join alice bob
  board alice send hello

  assert_contains "$(board bob wait)" hello
)

wait_for_new_message() (
  join alice bob
  (sleep 1 && board alice send hello) &

  assert_contains "$(board bob wait -t 10)" hello
  wait
)

time_out_waiting() (
  join alice

  assert_fails board alice wait -t 1
)

wait_with_invalid_timeout() (
  join alice

  assert_fails board alice wait -t soon
)

# Channels

name_channel_after_directory() (
  assert_contains "$(board alice list)" "work
  claude-alice (you)"
)

name_channel_after_nested_directory() (
  assert_contains "$(in_directory team/project board alice list)" "team_project
  claude-alice (you)"
)

name_channel_after_hidden_directory() (
  in_directory .hidden join alice bob
  in_directory .hidden board alice send hello

  assert_contains "$(in_directory .hidden board alice list)" "_hidden
  claude-alice (you)"
  assert_contains "$(in_directory .hidden board bob read)" hello
)

name_channel_after_directory_with_dot() (
  assert_contains "$(in_directory example.com board alice list)" "example_com
  claude-alice (you)"
)

share_channel_with_worktree() (
  git init -q "$home/repository"
  git -C "$home/repository" -c user.name=test -c user.email=test@example.com -c commit.gpgsign=false \
    commit -q --allow-empty -m Test
  git -C "$home/repository" worktree add -q "$home/worktree"

  in_directory repository/directory join alice

  agents=$(in_directory worktree board bob list)

  assert_contains "$agents" "repository
  claude-alice"
  assert_contains "$agents" "  claude-bob (you)"
  assert_contains "$(echo "$agents" | grep -c '^[^ ]')" 1
)

separate_channels() (
  join alice
  board alice send hello

  assert_contains "$(in_directory other board bob join)" "No unread messages."
)

list_agents_on_other_channel() (
  join alice

  agents=$(in_directory other board bob list)

  assert_contains "$agents" "other
  claude-bob (you)"
  assert_contains "$agents" "work
  claude-alice"
)

send_message_to_channel() (
  join alice dave
  in_directory other join bob carol
  board alice send -c other hello

  assert_contains "$(in_directory other board bob read)" hello
  assert_contains "$(in_directory other board carol read)" hello
  assert_contains "$(board dave read)" "No unread messages."
)

send_message_to_channel_of_nested_directory() (
  join alice
  in_directory team/project join bob
  board alice send -c team/project hello

  assert_contains "$(in_directory team/project board bob read)" hello
)

send_message_to_channel_of_hidden_directory() (
  join alice
  in_directory .hidden join bob
  board alice send -c .hidden hello

  assert_contains "$(in_directory .hidden board bob read)" hello
)

send_message_to_agent_on_other_channel() (
  join alice
  in_directory other join bob
  board alice send -t claude-bob hello

  assert_contains "$(in_directory other board bob read)" hello
)

catch_up_on_message_from_other_channel() (
  join alice
  board alice send -c other hello

  assert_contains "$(in_directory other board bob join)" hello
)

catch_up_on_no_message_from_agent_itself() (
  join alice
  board alice send -c other hello

  assert_contains "$(in_directory other board alice join)" "No unread messages."
)

read_message_in_other_directory() (
  join alice bob
  in_directory other join bob
  board alice send hello

  assert_contains "$(in_directory other board bob read)" hello
)

leave_every_channel() (
  join alice bob
  in_directory other join bob
  board bob leave

  assert_not_contains "$(board alice list)" bob
)

prune_stale_agent_on_other_channel() (
  join alice
  in_directory other join bob
  touch -t 200001010000 "$directory/other/agents/claude-bob"

  assert_not_contains "$(board alice list)" bob
)

keep_channel_in_board() (
  join alice

  for channel in ../other team/../../other; do
    board alice send -c "$channel" hello
  done

  assert_not_contains "$(ls "$home/.cache/agents")" other
)

send_message_to_invalid_channel() (
  join alice

  for channel in "" . .. "team
project"; do
    assert_fails board alice send -c "$channel" hello
  done
)

join_channel_of_invalid_directory() (
  assert_fails in_directory "team
project" board alice join
)

# Names

name_agent_after_codex_session() (
  agents=$(run_board CODEX_THREAD_ID=01a1f7ab-354e-7d02-8d1c-0123456789ab "$command" list)

  assert_contains "$agents" "codex-0123456789ab (you)"
)

name_agent_after_claude_session() (
  agents=$(run_board CLAUDE_CODE_SESSION_ID=a66b24e8-9d15-4f74-b8c5-ba9876543210 "$command" list)

  assert_contains "$agents" "claude-ba9876543210 (you)"
)

name_agent_after_inner_session() (
  agents=$(
    run_board CLAUDE_CODE_SESSION_ID=a66b24e8-9d15-4f74-b8c5-ba9876543210 \
      CODEX_THREAD_ID=01a1f7ab-354e-7d02-8d1c-0123456789ab "$command" list
  )

  assert_contains "$agents" "codex-0123456789ab (you)"
)

name_no_agent() (
  assert_fails run_board "$command" list
)

reject_invalid_agent_name() (
  for agent in alice/bob "alice bob"; do
    assert_fails board "$agent" list
  done
)

# Usage

show_help() (
  assert_contains "$(board alice help)" "Usage: agent-board"
)

run_no_command() (
  assert_fails board alice
)

run_unknown_command() (
  assert_fails board alice dance
)

for name in $(sed -n '1,/^run() ($/d; s/^\([^ ]*\)() ($/\1/p' "$0"); do
  run "$name"
done
