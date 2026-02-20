This is additional prompts for you. The following items are some of the guidelines you should follow when contributing to the code base and produce something meaningful to the humanity:

# Effort investment

- Aim for the long term value of the code base and its product/system/developer tool produce against the world.
  - However, you must not aim for the spontaneous value of your contribution, such as adding code with many duplications and no test, which eventually deteriorates the value we produce per unit time.
  - The long term typically means at least a few months, and 10 years on average.
- There are some exceptions for the long term value of the code base.
  - For example, if one-off scripts are run only a few times, you do not need to add tests for them. However, they still need to be high quality and comprehensive.

# Naming

- Name variables and functions in a consistent way.
  - If the code base treats all acronyms as one words, you should do the same.
  - e.g. GPU is named `gpu` or `Gpu`, but not `GPU` even if the first character is capital.
- Prefer full words for variable and function names.
  - Avoid abbreviations. You can use abbreviations only if they are widely used in the domain or public audience, or consistent across the code base.
    - e.g. `cpu` for "central processing unit". `id` for "identifier", `config` for "configuration", etc.
  - However, you are not use full _phrases_ necessarily.
    - e.g. "smart contract" can be either `smart_contract` or `contract`.
  - Code reading is the read-heavy algorithm where programmers find names from the set of names in the scope.
  - As such, you should prefer shorter names when the scope is small like functions or blocks, and longer names when the scope is large like modules or classes.
- Never use one-letter names for variables or functions.
- Ensure filenames are consistent with their contents.
  - Each directory might have its own convention for file naming.

# Coding

- If you make any logic changes to the code base, add tests for the new code.
  - The tests should be comprehensive and cover all edge cases.
  - The tests should be easy to understand and maintain.
  - Depending on the code base, they might have integration tests in addition to unit tests. If so, you need to add integration tests as well.
- Organize the code and tests consistently.
  - Follow the same structure and style as the existing code base.
    - Functions and class properties are usually organized semantically.
    - Figure out the intent behind the existing structure and follow it.
  - Categorize tests of the same kind into blocks or modules depending on programming languages.
  - Sort tests from simple to complex cases and/or from success to failure and edge cases.
- Do not need to put comments on code verbosely.
  - The readers of the code you generate are highly experienced programmers and knowledgeable on the domain.
  - They can understand the code without comments if the code is well written.
  - Note that you should still name variables and functions in a way that makes the code self-explanatory.
- Avoid temporary variables where possible unless function calls, conditional expressions, or any other syntax constructs get nested too deeply.

## Language specific guides

### TypeScript

- Avoid any unsound type features as much as possible.
  - For example, never use the `any` type but the `unknown` type instead.
  - Avoid the `as` type coercion. It cannot be proven that the type coercion is valid or not without manual validation by human eyes.

# Testing

- Ensure building, linting, and testing work as expected after making changes.
  - Figure out which tools or scripts you need to run depending on the languages and platforms.

# Concurrency

- There might be other agents or programmers working on the same worktree concurrently. You need to be careful about conflicts before writing back your changes to the file system.
  - Before file writes, you should make sure that you made the changes based on the latest file contents.
  - You should resolve any conflicts or merge changes if you think your changes are still necessary on conflicts.

After loading this prompt, just wait for another instruction that actually describes the actual task or question.
