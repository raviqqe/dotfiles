---
name: implement
description: Implement a design as pull requests in relevant repositories.
---

# Implementation of a design

## Process

1. Read the given design document, or use the design discussed so far in the chat if none is given.
   - The design document might be given as a local file, an online document, etc.
2. Plan pull requests that implement the design in all relevant repositories.
   - Decide the interfaces, protocols, and data formats shared among the pull requests so that they can be implemented independently.
3. Run the following steps for each pull request concurrently with the others, delegating each step to a sub-agent if sub-agents are available.
   1. Implement the pull request.
   2. Audit it following the `review` skill with a sub-agent other than the one that implemented it.
   3. Review its style following the `review-style` skill concurrently with the audit with yet another sub-agent.
   4. If there are any audit findings of medium severity or above or any stylistic findings, fix them and repeat from the audit until only audit findings of low severity or lower remain.
   5. Create the pull request.
   - Give each sub-agent all the details of the design, the plan, and the earlier steps that it needs because sub-agents might not see the chat.
   - Work on each pull request in its own worktree or clone so that pull requests never interfere with each other or with any existing worktree.
4. Report a summary of each pull request and its resolved and remaining findings with their resolution verdicts if any at the end.
   - The agent that the user asked to run this skill reports them rather than its sub-agents.
