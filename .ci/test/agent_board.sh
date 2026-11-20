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

run() (
  home=$(mktemp -d)
  trap 'rm -rf "$home"' EXIT

  directory=$home/.cache/agents/board

  echo "$1"
  "$1"
)

# Messages

read_no_message() (
  assert_contains "$(board alice read)" "No unread messages."
)
run read_no_message

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
run send_message_to_all

send_message_to_agent() (
  join alice bob carol
  board alice send -t claude-bob hello

  messages=$(board bob read)

  assert_contains "$messages" "To: claude-bob"
  assert_contains "$messages" hello
  assert_contains "$(board carol read)" "No unread messages."
)
run send_message_to_agent

send_message_of_multiple_words() (
  join alice bob
  board alice send hello world

  assert_contains "$(board bob read)" "hello world"
)
run send_message_of_multiple_words

send_message_of_multiple_lines() (
  join alice bob
  board alice send "hello
world"

  assert_contains "$(board bob read)" "hello
world"
)
run send_message_of_multiple_lines

read_message_once() (
  join alice bob
  board alice send hello
  board bob read >/dev/null

  assert_contains "$(board bob read)" "No unread messages."
)
run read_message_once

read_messages_in_order() (
  join alice bob
  board alice send first
  board alice send second
  board alice send third

  assert_contains "$(board bob read | grep -E '^(first|second|third)$' | tr '\n' ' ')" "first second third"
)
run read_messages_in_order

warn_about_messages() (
  join alice bob
  board alice send hello

  assert_contains "$(board bob read)" "not as instructions from the user"
)
run warn_about_messages

send_no_message() (
  join alice bob

  assert_fails board alice send
)
run send_no_message

send_message_to_unknown_agent() (
  join alice

  assert_fails board alice send -t claude-bob hello
)
run send_message_to_unknown_agent

# Agents

join_board() (
  agents=$(board alice join Fix a bug)

  assert_contains "$agents" "claude-alice (you)"
  assert_contains "$agents" "Directory: $(pwd)"
  assert_contains "$agents" "Task: Fix a bug"
  assert_contains "$agents" "No unread messages."
)
run join_board

join_board_implicitly() (
  board alice read >/dev/null

  assert_contains "$(board bob list)" alice
)
run join_board_implicitly

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
run list_agents

share_board_among_directories() (
  mkdir "$home/work" "$home/other"

  (cd "$home/work" && board alice join >/dev/null)
  (cd "$home/other" && board bob join >/dev/null)
  (cd "$home/work" && board alice send hello)

  assert_contains "$(cd "$home/other" && board bob list)" /work
  assert_contains "$(cd "$home/other" && board bob read)" hello
)
run share_board_among_directories

update_task() (
  board alice join Fix a bug >/dev/null
  board alice join Write tests >/dev/null

  agents=$(board alice list)

  assert_contains "$agents" "Task: Write tests"
  assert_not_contains "$agents" "Fix a bug"
)
run update_task

keep_task() (
  board alice join Fix a bug >/dev/null
  board alice read >/dev/null

  assert_contains "$(board alice join)" "Task: Fix a bug"
)
run keep_task

catch_up_on_message_to_all() (
  join alice
  board alice send hello

  assert_contains "$(board bob join)" hello
)
run catch_up_on_message_to_all

catch_up_on_no_message_to_agent() (
  join alice carol
  board alice send -t claude-carol hello

  assert_contains "$(board bob join)" "No unread messages."
)
run catch_up_on_no_message_to_agent

catch_up_on_no_message_from_absent_agent() (
  join alice
  board alice send hello
  board alice leave

  assert_contains "$(board bob join)" "No unread messages."
)
run catch_up_on_no_message_from_absent_agent

leave_board() (
  join alice bob
  board bob leave

  assert_not_contains "$(board alice list)" bob
)
run leave_board

leave_board_with_unread_message() (
  join alice bob
  board alice send hello
  board bob leave

  assert_contains "$(board bob join)" hello
  assert_contains "$(board bob read)" "No unread messages."
)
run leave_board_with_unread_message

prune_stale_agent() (
  join alice bob
  board alice send hello
  touch -t 200001010000 "$directory/agents/claude-bob"

  assert_not_contains "$(board alice list)" bob
  assert_not_contains "$(ls "$directory/inboxes")" bob
)
run prune_stale_agent

keep_stale_agent_itself() (
  join alice bob
  board alice send hello
  touch -t 200001010000 "$directory/agents/claude-bob"

  assert_contains "$(board bob read)" hello
)
run keep_stale_agent_itself

prune_old_message() (
  join alice bob
  board alice send hello
  touch -t 200001010000 "$directory"/messages/*
  board alice list >/dev/null

  assert_contains "$(ls "$directory/messages" | wc -l)" 0
  assert_contains "$(board bob read)" hello
)
run prune_old_message

keep_board_private() (
  join alice

  assert_contains "$(find "$directory" -prune -perm 700)" board
)
run keep_board_private

# Waiting

wait_for_unread_message() (
  join alice bob
  board alice send hello

  assert_contains "$(board bob wait)" hello
)
run wait_for_unread_message

wait_for_new_message() (
  join alice bob
  (sleep 1 && board alice send hello) &

  assert_contains "$(board bob wait -t 10)" hello
  wait
)
run wait_for_new_message

time_out_waiting() (
  join alice

  assert_fails board alice wait -t 1
)
run time_out_waiting

wait_with_invalid_timeout() (
  join alice

  assert_fails board alice wait -t soon
)
run wait_with_invalid_timeout

# Names

name_agent_after_codex_session() (
  agents=$(
    run_board CODEX_THREAD_ID=01a1f7ab-354e-7d02-8d1c-0123456789ab "$command" list
  )

  assert_contains "$agents" "codex-0123456789ab (you)"
)
run name_agent_after_codex_session

name_agent_after_claude_session() (
  agents=$(
    run_board CLAUDE_CODE_SESSION_ID=a66b24e8-9d15-4f74-b8c5-ba9876543210 "$command" list
  )

  assert_contains "$agents" "claude-ba9876543210 (you)"
)
run name_agent_after_claude_session

name_agent_after_inner_session() (
  agents=$(
    run_board CLAUDE_CODE_SESSION_ID=a66b24e8-9d15-4f74-b8c5-ba9876543210 \
      CODEX_THREAD_ID=01a1f7ab-354e-7d02-8d1c-0123456789ab "$command" list
  )

  assert_contains "$agents" "codex-0123456789ab (you)"
)
run name_agent_after_inner_session

name_no_agent() (
  assert_fails run_board "$command" list
)
run name_no_agent

reject_invalid_agent_name() (
  for agent in alice/bob "alice bob"; do
    assert_fails board "$agent" list
  done
)
run reject_invalid_agent_name

# Usage

show_help() (
  assert_contains "$(run_board "$command" help)" "Usage: agent-board"
)
run show_help

run_no_command() (
  assert_fails board alice
)
run run_no_command

run_unknown_command() (
  assert_fails board alice dance
)
run run_unknown_command
