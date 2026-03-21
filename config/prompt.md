This is additional prompts for you. The following items are some of the guidelines you should follow when contributing to the code base and produce something meaningful for the humanity:

# Effort investment

- Aim for the long-term value that the code base and the products/systems/developer tools built on top of it provide to the world.
  - However, you must not aim for the short-term value of your contribution, such as adding code with many duplications and no tests, which eventually deteriorates the value we produce per unit time.
  - The long term typically means at least a few months, and 10 years on average.
- There are some exceptions for the long term value of the code base.
  - For example, if one-off scripts are run only a few times, you do not need to add tests for them. However, they still need to be high quality and comprehensive.
- Do not make any unnecessary changes.
  - Reviewing code is very costly and requires human intervention.
  - Think twice before making changes if they are truly necessary for the given task.
- If you are stuck on thinking or finding solutions over 5 minutes, do not hesitate to ask for help, get feedback from, or ask questions to users.

# Naming

- Name variables and functions in a consistent way.
  - If the code base treats all acronyms as one word, you should do the same.
  - e.g. GPU is named `gpu` or `Gpu`, but not `GPU` even if the first character is capitalized.
- Prefer full words for variable and function names.
  - Avoid abbreviations. You can use abbreviations only if they are widely used in the domain or public audience, or consistent across the code base.
    - e.g. `cpu` for "central processing unit". `id` for "identifier", `config` for "configuration", etc.
  - However, you do not use full _phrases_ necessarily.
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
- Avoid any temporary variables as much as possible unless that makes the code less DRY.
  - Inline expressions or statements used only once into their use locations even when they nest deeply.
  - Remembering state of the code flow is much more costly for readers of the code.
- Shadow variables with no hesitation.
  - In this era when we encourage the functional programming and immutable data, variable shadowing is rather a technique to bind variables to new values without mutating data actually.

# Styling

- If you see any differences on the coding standards or styling in the existing code base, take the one written by Yota Toyama as the gold standard.
  - You can use `git blame` to find out who wrote which lines of code.

# Commenting

- Do not put comments on code verbosely.
  - The readers of the code you generate are highly experienced programmers and knowledgeable on the domain.
  - They can understand the code without comments if the code is well written.
  - Note that you should still name variables and functions in a way that makes the code self-explanatory.
- Write comments in natural language.
  - You should not use function or variable names in the code directly in comments.
  - e.g. `GPU usage` instead of `gpuUsage`
- Synchronize all comments and documentation with code changes in the code base.
  - If you make any logic changes to the code base, you should also update comments and documentation accordingly if any.
  - Outdated comments and documentation are worse than no comments and documentation because they mislead readers of the code.

# Testing

- Ensure building, linting, and testing work as expected after making changes.
  - Figure out which tools or scripts you need to run depending on the languages and platforms.

# Concurrency

- There might be other agents or programmers working on the same worktree concurrently. You need to be careful about conflicts before writing back your changes to the file system.
  - Before file writes, you should make sure that you made the changes based on the latest file contents.
  - You should resolve any conflicts or merge changes if you think your changes are still necessary on conflicts.
- Never amend commits.
  - The existing commits might potentially be made by developers or agents working on the same worktree concurrently.
  - Instead, leave the changes without committing them or create new commits on top of the existing commits.

# Software architecture

- Follow the principles in Clean Architecture by Robert C. Martin.
- Follow the SOLID principles.
- Do not apply the terminology in these principles naively or strictly.
  - The existing code base might have different conventions already. Then, follow the existing ones.
- However, do not need to follow these principles strictly if that incurs too much development cost.
- At the very least level, separate layers of software when you find significant gaps between them.
  - For example, abstract away details of databases, key management systems, external APIs, etc. using general data types and interfaces.
- Note that the most important principle is still the one mentioned at the top:
  - Aim for the long-term value of the software.

## Language specific guides

### TypeScript

- Avoid any unsound type features as much as possible.
  - For example, never use the `any` type but the `unknown` type instead.
  - Avoid the `as` type coercion unless strictly necessary (e.g. interfacing with external libraries, or complex type narrowing that cannot be achieved otherwise).
    - It cannot be proven that the type coercion is valid or not without manual validation by human eyes because the `as` operator is unsound.
- Prefer arrow functions.
  - They look simpler visually.
  - It also prevents the misuse of the `this` keyword.
- For test names in Vitest, use the natural language.
  - If we use the `it` test function, start test names with the third-person singular forms of verbs.
    - e.g. `parses foo` instead of `parse foo` or `parsing works`.
  - Use words in the natural language instead of variable and function names used in the code.
    - e.g. `GPU usage` instead of `gpuUsage`.
- Use tools used in each project.
  - For example, when you find a lock file for npm packages, use the corresponding package manager to install dependencies and run scripts.
    - e.g. `npm` for `package-lock.json`, `yarn` for `yarn.lock`, and `pnpm` for `pnpm-lock.yaml`.

### Rust

- Ensure building, linting, format check, testing work as expected after making changes.
  - e.g. `cargo build`, `cargo clippy`, `cargo fmt --check`, and `cargo test`.
  - Depending on projects, they might use other tools and scripts, or might not use the ones listed above.
- Test names should follow imperative forms.
  - e.g. `parse_foo` instead of `parses_foo` or `foo_parsing`.
- Do not prefix test names with `test_` because the test functions are already annotated with `#[test]`.
- Do not prefix test sub-modules under the `#[cfg(test)] tests { ... }` modules with `tests_` as they are also redundant.
- Ensure that all the code is formatted well with `cargo +nightly fmt --all` after code changes.
- Prefer the functional programming and immutable data always.
  - The programming style without state mutation always simplifies the logic even when they result in deeply nested expressions or long method chains.
- Specify full semantic versions (e.g. `1.2.3`) in `Cargo.toml` files always.
- Use names from external crates without prefixing them with the crate or module names if there is no ambiguity.
  - e.g. `Result` instead of `std::result::Result` and `join_all` for `futures::future::join_all`.
- Never use `mod.rs` files for module definitions.
  - Instead, use `<module_name>.rs` files and `<module_name>` directories.

After loading this prompt, just wait for another instruction that actually describes the actual task or question.
