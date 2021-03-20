# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changes

- Go back to Binding object on initializer (BREAKING)

## [0.3.0] - 2021-03-21

### Enhancements

- Add CHANGELOG.md
- Setup CI environments

### Adds

- Add videoGravity setup in initializer (BREAKING)

### Fixes

- Subscription will drop first metadata output if nil, to prevent writing in @States, which might be bound to, during view rendering.

## [0.2.0] - 2021-03-19

### Changes

- Using setting closure rather than Binding object on initializer (BREAKING)

## [0.1.0] - 2021-03-19

- Initial release.
