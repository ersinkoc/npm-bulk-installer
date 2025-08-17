# Contributing to NPM Bulk Installer

First off, thank you for considering contributing to NPM Bulk Installer! It's people like you that make this tool better for everyone.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples**
- **Include your environment details** (OS, Node.js version, npm version)
- **Include relevant log files**

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description of the suggested enhancement**
- **Explain why this enhancement would be useful**
- **List any alternative solutions you've considered**

### Pull Requests

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Development Guidelines

### Script Standards

#### PowerShell (.ps1)
- Use approved PowerShell verbs
- Include proper error handling
- Add comments for complex logic
- Test on Windows PowerShell 5.1+

#### Bash (.sh)
- Use shellcheck for validation
- Ensure POSIX compliance where possible
- Test on both Linux and macOS
- Include shebang: `#!/bin/bash`

#### Batch (.bat)
- Test on Windows 10 and Windows 11
- Use `setlocal enabledelayedexpansion` when needed
- Handle spaces in paths properly

### Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

### Testing

Before submitting a PR, ensure:
1. The script runs without errors on its target platform
2. All existing functionality still works
3. New features are documented in README.md
4. Complex logic includes comments

## Code of Conduct

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

Examples of behavior that contributes to creating a positive environment include:

- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

## Questions?

Feel free to open an issue with your question or contact the maintainer directly.

Thank you for contributing! 🎉

---
**Author**: Ersin KOÇ  
**Date**: 2025-08-17