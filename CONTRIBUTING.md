# Contributing to FingerBeat

Thank you for your interest in contributing to FingerBeat! This document provides guidelines for contributing to the project.

## Development Setup

1. Install [DevEco Studio](https://developer.huawei.com/consumer/cn/deveco-studio/) 5.0+
2. Clone the repository and open in DevEco Studio
3. Wait for OHPM to install dependencies
4. Build the project to verify everything works

## Project Architecture

FingerBeat uses a multi-module architecture:

- `products/default` - Entry module (UI shell)
- `features/game` - Game engine core (HAR)
- `common` - Shared utilities (HAR)

Please respect module boundaries when making changes. The game engine (`features/game`) should not depend on UI code from the entry module.

## Code Style

- Follow the existing ArkTS coding conventions in the project
- The project uses `@performance/recommended` + `@typescript-eslint/recommended` lint rules (see `code-linter.json5`)
- Run lint checks before submitting: code changes must pass all lint rules

## Making Changes

1. Create a branch for your feature or fix: `git checkout -b feature/my-feature`
2. Make your changes with clear, focused commits
3. Add or update tests as appropriate
4. Ensure all existing tests pass
5. Push your branch and open a Pull Request

## Commit Messages

- Use clear, descriptive commit messages
- Prefix with type: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`
- Example: `feat: add hold note support to JudgeSystem`

## Pull Requests

- Provide a clear description of the change and its motivation
- Reference any related issues
- Keep PRs focused on a single concern
- Ensure CI checks pass (when configured)

## Reporting Issues

- Use GitHub Issues to report bugs or request features
- Include steps to reproduce for bug reports
- Specify your HarmonyOS SDK version and device type

## License

By contributing, you agree that your contributions will be licensed under the Apache-2.0 License.
