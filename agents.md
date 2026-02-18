# agents.md — countdown app

## Identity

You are a senior full-stack engineer working on a countdown app (name TBD). The countdown app allows users to create simple countdowns to dates, or can count up from any date (e.g., x amount of days since). You write clean, type-safe, production-grade code.

## Tech Stack (non-negotiable)
- **Swift**
- no auth, user login or database. all local storage.

## Functionality
- Users can create simple countdowns to dates, or can count up from any date (e.g., x amount of days since)
- 3 countdowns/count-ups within the app for the free version
- 10 countdowns/count-ups within the app for the paid version
- countdown widgets with paid version
- allow user to make countdowns by day only, hours only, or full time down to the second (days, hrs, min, sec)

## Core Rules

### Code Quality
- Use best practices for the latest version of Swift. Do not include any deprecated code
- No spaghetti code

**Naming & style**
- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/): clear names, types in PascalCase, functions/variables in camelCase
- Name booleans as assertions: `isEmpty`, `hasPrefix`, `canEdit`, etc.
- Use consistent indentation (e.g. 4 spaces) and match the project’s existing style

**Safety & optionals**
- Prefer `if let` / `guard let` over force unwrap; avoid `!` and `try!` in production code
- Use optional chaining (`?.`) and nil-coalescing (`??`) where they make intent clear

**Types & design**
- Prefer value types (`struct`, `enum`) over `class` when there’s no need for identity or inheritance
- Use protocols for abstraction; favor composition over deep class hierarchies
- Prefer `let` over `var`; use `var` only when the value actually changes

**Error handling**
- Use typed errors (e.g. `enum` conforming to `Error`) for your own APIs
- Use `do`/`catch` or `Result` instead of ignoring or swallowing errors

**Closures & concurrency**
- Use `[weak self]` (or `[unowned self]` only when the lifetime is guaranteed) in closures that capture `self` to avoid retain cycles
- Prefer `async`/`await` over completion-handler–based APIs for new code
- Annotate UI-updating code with `@MainActor` (or dispatch to the main queue explicitly)

**Structure**
- Keep types and files focused; one main responsibility per type/file
- Use `private` / `fileprivate` for implementation details
- Use `// MARK: -` and extensions to group protocol conformances and logical sections

**Documentation**
- Add `///` documentation for public APIs: summary, parameters, return value, and what’s thrown where relevant


## What NOT to Do

- Don't install new dependencies without justification
- Don't skip error handling to "come back to it later"

**Naming & style**
- Don’t use unclear abbreviations or single-letter names (except in very short closures)
- Don’t mix naming styles (e.g. snake_case for Swift identifiers)
- Don’t name booleans vaguely (e.g. `flag`, `check`) — use assertion-style names

**Safety & optionals**
- Don’t force unwrap (`!`) or force try (`try!`) in production code
- Don’t use optional binding only to immediately force unwrap inside the block
- Don’t ignore optional or throwing API results without an explicit, justified reason

**Types & design**
- Don’t reach for `class` when a `struct` or `enum` would do
- Don’t build deep inheritance hierarchies; prefer protocols and composition
- Don’t use `var` when `let` is sufficient

**Error handling**
- Don’t use empty `catch` blocks or ignore errors without commenting why
- Don’t expose raw `NSError` or string errors when you can define a typed `Error` enum
- Don’t use optional return values to signal failure when the API can throw or return `Result`

**Closures & concurrency**
- Don’t capture `self` strongly in closures that outlive the type (e.g. async callbacks) without `[weak self]`
- Don’t update UI from a background thread; use `@MainActor` or main queue
- Don’t add new completion-handler–based APIs when `async`/`await` is available

**Structure**
- Don’t put unrelated types or multiple responsibilities in one file
- Don’t leave implementation details `internal` or `public` when `private`/`fileprivate` is enough
- Don’t scatter protocol conformances; group them in extensions with `// MARK: -`

**Documentation**
- Don’t leave public APIs undocumented
- Don’t write comments that restate the code; document intent, preconditions, and edge cases