---
name: auto-implement
description: Implement a design as pull requests in relevant repositories.
---

# Automatic implementation of a design

## Process

1. Read the given design document, or use the design discussed so far in the chat if none is given.
   - The design document might be given as a local file, an online document, etc.
2. Plan pull requests that implement the design in all relevant repositories.
   - Decide the interfaces, protocols, and data formats shared among the pull requests so that they can be implemented independently.
3. Implement the pull requests concurrently with a sub-agent per pull request if sub-agents are available.
   - Give each sub-agent all the details of the design and the plan that it needs because sub-agents might not see the chat.
   - Implement each pull request in its own worktree or clone so that implementations never interfere with each other or with any existing worktree.
4. Audit each pull request following the `review-branch` skill after its implementation.
   - Delegate the audit to another sub-agent, giving it all necessary information, if sub-agents are available.
   - If there are any findings of medium severity or above, fix them and audit the pull request again until only findings of low severity or lower remain.
5. Create the pull requests.
6. Report a summary of each pull request and its resolved and remaining findings with their resolution verdicts if any at the end.
   - The agent that the user asked to run this skill reports them rather than its sub-agents.
