# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing shell configuration files for macOS development environment setup. The repository includes zsh shell configurations with Oh My Zsh, Powerlevel10k theme, and various development tools PATH configurations.

## Key Files and Structure

- `.zshrc` - Main zsh configuration with Oh My Zsh setup and Powerlevel10k theme
- `.zprofile` - Environment variables and PATH configurations for development tools
- `README.md` - Basic repository description

## Environment Setup Commands

### Installing/Applying Dotfiles
```bash
# Copy configurations to home directory
cp .zshrc ~/.zshrc
cp .zprofile ~/.zprofile

# Reload shell configuration
source ~/.zshrc
source ~/.zprofile
```

### Backup Current Configuration
```bash
# Backup existing dotfiles before applying new ones
cp ~/.zshrc ~/.zshrc.backup
cp ~/.zprofile ~/.zprofile.backup
```

### Verify Configuration
```bash
# Check if Oh My Zsh is installed
ls -la ~/.oh-my-zsh

# Check if Powerlevel10k theme is available
ls -la ~/.oh-my-zsh/themes/powerlevel10k

# Verify PATH configurations
echo $PATH | tr ':' '\n'
```

## Development Environment

### Tools and Applications Configured
The dotfiles configure PATH variables for:

- **Java Development**: Java Home and Maven
- **Code Editors**: Visual Studio Code (`code` command), Sublime Text (`subl` command)
- **Mobile Development**: Flutter SDK, Android SDK platform-tools
- **Package Managers**: Homebrew, MacPorts
- **Version Control**: Repo tool for Android development
- **Node.js**: NVM (Node Version Manager)
- **JetBrains**: Toolbox App scripts

### Shell Features
- **Theme**: Powerlevel10k with instant prompt for fast shell startup
- **Framework**: Oh My Zsh with git plugin
- **Node Management**: NVM integration for Node.js version management

## Architecture Notes

### Configuration Loading Order
1. `.zprofile` - Loaded first for login shells (environment variables, PATH)
2. `.zshrc` - Loaded for interactive shells (aliases, functions, Oh My Zsh)

### PATH Management Strategy
- System paths (HomeBrew, MacPorts) are prioritized at the beginning
- Development tool paths are appended to avoid conflicts
- JetBrains Toolbox scripts are added last

### Theme Configuration
- Uses Powerlevel10k instant prompt for performance
- Prompt configuration stored in `~/.p10k.zsh` (not in this repository)
- Falls back gracefully if theme files are missing

## Common Workflows

### Adding New Development Tools
When adding new development tools to PATH:
1. Add export statements to `.zprofile`
2. Test the configuration in a new shell session
3. Update this WARP.md if the tool requires special setup steps

### Shell Customization
- Modify `.zshrc` for shell behavior, aliases, and functions
- Modify `.zprofile` for environment variables and PATH changes
- Run `p10k configure` to customize the Powerlevel10k theme

### Troubleshooting
```bash
# Check for shell configuration errors
zsh -n ~/.zshrc  # Syntax check
zsh -n ~/.zprofile  # Syntax check

# Debug PATH issues
which <command_name>  # Find which version of a command is being used
type <command_name>   # Show command type and location
```