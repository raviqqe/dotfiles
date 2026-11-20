---
name: review-branch
description: Review a branch in the Zellic style.
---

# Zellic-style code review for a branch

## Process

1. Audit all changes in the given branch, or in the current branch if none is given, following the `review` skill.
   - The branch might be given as a branch name, pull request number, pull request URL, etc.
2. If the changes involve any other repositories, assess them against the code bases of those repositories and their open pull requests related to the changes.
   - e.g. Repositories that the changes depend on, that depend on the changes, or that share interfaces, protocols, or data formats with them.
   - Check for incompatibilities, broken assumptions, and conflicts between the changes and the code on both sides.
3. Show a full audit report.
