# Contributing to WebODM-Setup

Thank you for your interest in contributing to WebODM-Setup! This document provides guidelines and instructions for contributing.

## 🤝 How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:

1. **Clear title** describing the bug
2. **Steps to reproduce** the issue
3. **Expected behavior** vs **actual behavior**
4. **Environment details**:
   - OS and version
   - Docker version
   - Python version (if relevant)
   - WebODM version
5. **Screenshots or logs** if applicable

### Suggesting Enhancements

We welcome feature requests! Please include:

1. **Use case** - what problem does this solve?
2. **Proposed solution** - how would it work?
3. **Alternatives considered** - other approaches?
4. **Additional context** - mockups, examples, etc.

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Make your changes**
4. **Test thoroughly**
5. **Commit with clear messages** (`git commit -m 'Add some AmazingFeature'`)
6. **Push to your fork** (`git push origin feature/AmazingFeature`)
7. **Open a Pull Request**

## 📝 Development Guidelines

### Code Style

**Python**:
- Follow PEP 8
- Use meaningful variable names
- Add docstrings to functions
- Include type hints where appropriate

**PowerShell**:
- Use approved verbs (Get-, Set-, New-, etc.)
- Add comment-based help
- Use proper error handling

**Bash**:
- Use shellcheck for validation
- Add comments for complex logic
- Use proper error handling with set -e

### Testing

Before submitting a PR:

1. **Test on your platform** (Windows/Linux/macOS)
2. **Test with sample data**
3. **Verify documentation** is updated
4. **Check for breaking changes**

### Documentation

- Update README.md if adding features
- Update QUICKSTART.md for user-facing changes
- Add examples to EXAMPLES.md
- Comment complex code sections

## 🔧 Development Setup

### Prerequisites

- Git
- Docker Desktop
- Python 3.8+
- Code editor (VS Code recommended)

### Setup Steps

1. **Fork and clone**
   ```bash
   git clone https://github.com/YOUR_USERNAME/WebODM-Setup.git
   cd WebODM-Setup
   ```

2. **Create virtual environment** (optional)
   ```bash
   python -m venv venv
   source venv/bin/activate  # Linux/macOS
   .\venv\Scripts\Activate.ps1  # Windows
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Test installation**
   ```bash
   # Windows
   .\scripts\install-windows.ps1
   
   # Linux/macOS
   ./scripts/install-linux.sh
   ```

## 📋 Project Structure

```
WebODM-Setup/
├── config/              # Configuration files
│   ├── webodm-config.env
│   └── processing-presets.json
├── scripts/             # Installation and utility scripts
│   ├── install-*.ps1/sh
│   ├── start-webodm.*
│   ├── stop-webodm.*
│   ├── update-webodm.*
│   ├── extract-frames.py
│   └── batch-process.py
├── docker-compose.yml   # Docker services definition
├── requirements.txt     # Python dependencies
├── README.md            # Main documentation
├── QUICKSTART.md        # Quick start guide
├── EXAMPLES.md          # Usage examples
└── CONTRIBUTING.md      # This file
```

## 🎯 Areas for Contribution

### High Priority

- [ ] Add GPU acceleration support
- [ ] Improve error handling and user feedback
- [ ] Add more video processing options
- [ ] Create automated tests
- [ ] Add support for more drone video formats

### Medium Priority

- [ ] Web interface for video processing
- [ ] Progress tracking for large batches
- [ ] Integration with cloud storage
- [ ] Multi-language support
- [ ] Performance optimizations

### Documentation

- [ ] Video tutorials
- [ ] More usage examples
- [ ] Troubleshooting guide expansion
- [ ] API documentation
- [ ] Architecture documentation

## ✅ Pull Request Checklist

Before submitting your PR, ensure:

- [ ] Code follows project style guidelines
- [ ] All tests pass
- [ ] Documentation is updated
- [ ] Commit messages are clear
- [ ] No merge conflicts
- [ ] PR description explains changes
- [ ] Related issues are referenced

## 🏷️ Commit Message Guidelines

Use clear, descriptive commit messages:

```
feat: Add support for MP4 video format
fix: Resolve frame extraction memory leak
docs: Update installation instructions
refactor: Simplify batch processing logic
test: Add unit tests for frame extraction
```

Prefixes:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation only
- `style:` Code style/formatting
- `refactor:` Code refactoring
- `test:` Adding tests
- `chore:` Maintenance tasks

## 🐛 Debugging

### Enable Debug Mode

```bash
# In docker-compose.yml
environment:
  - WO_DEBUG=YES
```

### View Detailed Logs

```bash
docker-compose logs -f webapp
```

### Common Issues

1. **Port conflicts**: Change WO_PORT in config
2. **Memory issues**: Increase Docker memory allocation
3. **Import errors**: Ensure all dependencies installed

## 📞 Getting Help

- **Questions**: Open a discussion on GitHub
- **Bugs**: Create an issue with details
- **Chat**: Join OpenDroneMap community forum

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🙏 Recognition

Contributors will be acknowledged in:
- README.md contributors section
- Release notes
- Project documentation

Thank you for contributing! 🎉
