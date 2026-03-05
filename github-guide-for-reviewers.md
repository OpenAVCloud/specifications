# GitHub Guide for Technical Reviewers

**Reviewing Requirements Documents with Comments and Pull Requests**

Edited March 5, 2026

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Getting a GitHub Account](#2-getting-a-github-account)
3. [Setting Up Git on Your Computer](#3-setting-up-git-on-your-computer)
4. [Understanding Key Concepts](#4-understanding-key-concepts)
5. [Reviewing Documents via the Web Interface](#5-reviewing-documents-via-the-web-interface)
6. [Reviewing Documents via the Command Line](#6-reviewing-documents-via-the-command-line)
7. [Using the GitHub CLI (gh)](#7-using-the-github-cli-gh)
8. [Best Practices for Document Reviews](#8-best-practices-for-document-reviews)
9. [Quick Reference](#9-quick-reference)

---

## 1. Introduction

This guide is designed for technical professionals who need to review requirements documents stored in GitHub. You will learn how to comment on specific sections, propose changes through pull requests, and collaborate effectively with your team.

GitHub is a platform built on Git, a distributed version control system. While Git tracks changes to files, GitHub provides a web interface and collaboration features that make it easier to review, discuss, and merge changes.

### What You Will Learn

- How to create and configure a GitHub account
- Setting up Git on Windows, macOS, and Linux
- Reviewing markdown documents through the web interface
- Creating pull requests with proposed changes
- Using Git and the GitHub CLI from the command line

---

## 2. Getting a GitHub Account

### Creating Your Account

1. Navigate to **https://github.com**
2. Click "Sign up" in the top right corner
3. Enter your email address (use your work email if reviewing work documents)
4. Create a strong password
5. Choose a username (this will be visible to collaborators)
6. Complete the verification puzzle and confirm your email

### Configuring Your Profile

After creating your account, configure your profile so team members can identify you:

- Click your avatar in the top right and select **Settings**
- Add your full name under **Public profile**
- Upload a professional photo (optional but recommended)
- Add your company or organization

### Enabling Two-Factor Authentication

Two-factor authentication (2FA) is strongly recommended and may be required by your organization:

1. Go to **Settings > Password and authentication**
2. Click **Enable two-factor authentication**
3. Choose your preferred method: authenticator app (recommended) or SMS
4. Save your recovery codes in a secure location

---

## 3. Setting Up Git on Your Computer

Git is the version control system that powers GitHub. You need it installed locally to clone repositories and make changes from the command line.

### Windows Installation

1. Download Git from **https://git-scm.com/download/win**
2. Run the installer with default options (or customize as needed)
3. When prompted for the default editor, choose your preferred text editor
4. Select "Git from the command line and also from 3rd-party software"
5. Complete the installation and open Git Bash or PowerShell to verify:

```bash
git --version
```

### macOS Installation

**Option 1: Using Homebrew** (recommended if you have Homebrew installed):

```bash
brew install git
```

**Option 2: Using Xcode Command Line Tools:**

```bash
xcode-select --install
```

**Option 3:** Download from https://git-scm.com/download/mac

Verify the installation:

```bash
git --version
```

### Linux Installation

**Debian/Ubuntu:**

```bash
sudo apt update && sudo apt install git
```

**Fedora:**

```bash
sudo dnf install git
```

**Arch Linux:**

```bash
sudo pacman -S git
```

Verify the installation:

```bash
git --version
```

### Configuring Git (All Platforms)

After installation, configure your identity. These details appear in your commits:

```bash
git config --global user.name "Your Full Name"
git config --global user.email "your.email@company.com"
```

Set your default branch name to `main` (matching GitHub's default):

```bash
git config --global init.defaultBranch main
```

Configure line endings (important for cross-platform teams):

**Windows:**

```bash
git config --global core.autocrlf true
```

**macOS/Linux:**

```bash
git config --global core.autocrlf input
```

### Setting Up SSH Authentication

SSH keys allow you to authenticate with GitHub without entering your password for every operation.

#### Generate an SSH Key

```bash
ssh-keygen -t ed25519 -C "your.email@company.com"
```

Press Enter to accept the default file location. Optionally set a passphrase for extra security.

#### Add the Key to Your SSH Agent

**Windows (Git Bash):**

```bash
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519
```

**macOS:**

```bash
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

**Linux:**

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

#### Add the Key to GitHub

1. Copy your public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

2. Go to **GitHub Settings > SSH and GPG keys > New SSH key**
3. Paste the key and give it a descriptive title (e.g., "Work Laptop")
4. Test the connection:

```bash
ssh -T git@github.com
```

You should see a message like: "Hi username! You've successfully authenticated..."

---

## 4. Understanding Key Concepts

### Essential Terminology

| Term | Definition |
|------|------------|
| **Repository** | A folder containing your project files and their complete history. Often called a "repo". |
| **Clone** | Creating a local copy of a repository on your computer. |
| **Branch** | An independent line of development. The default branch is usually `main`. |
| **Commit** | A snapshot of changes with a descriptive message. Each commit has a unique identifier. |
| **Pull Request** | A proposal to merge changes from one branch into another, with discussion and review. |
| **Fork** | A personal copy of someone else's repository under your account. |
| **Merge** | Combining changes from one branch into another. |
| **Issue** | A discussion thread for tracking tasks, bugs, or feature requests. |

### The Review Workflow

When reviewing requirements documents, you typically follow one of two workflows:

**Comment-Only Review:** Use this when you want to provide feedback without making changes yourself. You add comments directly on specific lines or sections.

**Pull Request Review:** Use this when you want to propose specific changes. You create a branch, make edits, and submit a pull request for others to review.

---

## 5. Reviewing Documents via the Web Interface

The GitHub web interface is the easiest way to review documents without installing any software beyond a web browser.

### Navigating to the Document

1. Open the repository URL in your browser
2. Navigate to the file by clicking through folders or using the file finder (press `t`)
3. Markdown files (`.md`) are rendered by default; click **Code** to see the raw markup

### Adding Comments via Issues

Issues are useful for general feedback or discussion about the document:

1. Click the **Issues** tab in the repository
2. Click **New issue**
3. Add a descriptive title (e.g., "Clarification needed: Section 3.2 Requirements")
4. Write your comments in the body using markdown formatting
5. Use code blocks to quote specific sections:

```markdown
```
The system shall support up to 1000 concurrent users.
```

Question: Is this a hard limit or a target?
```

### Creating a Pull Request with Changes

When you want to propose specific edits to a document:

#### Step 1: Create a New Branch

1. Navigate to the file you want to edit
2. Click the pencil icon (**Edit this file**) in the top right
3. GitHub automatically suggests creating a new branch for your changes

#### Step 2: Make Your Changes

- Edit the markdown content directly in the browser
- Use the **Preview** tab to see how your changes will render
- Add a clear commit message describing what you changed

#### Step 3: Create the Pull Request

1. Select **"Create a new branch for this commit and start a pull request"**
2. Name your branch descriptively (e.g., `update-security-requirements`)
3. Click **Propose changes**
4. Fill in the pull request template:
   - **Title:** Brief summary of changes
   - **Description:** Explain why you made these changes
   - **Reviewers:** Tag relevant team members if known
5. Click **Create pull request**

### Reviewing Someone Else's Pull Request

1. Go to the **Pull requests** tab in the repository
2. Click on the pull request you want to review
3. Click the **Files changed** tab to see the diff
4. Hover over a line and click the **+** to add a comment on that line
5. Click **Start a review** to batch multiple comments
6. When finished, click **Review changes** and select:
   - **Comment:** General feedback without approval/rejection
   - **Approve:** Changes look good
   - **Request changes:** Changes are needed before merging

---

## 6. Reviewing Documents via the Command Line

The command line gives you more control and is essential for complex workflows.

### Cloning a Repository

First, get a local copy of the repository:

```bash
git clone git@github.com:organization/repository.git
cd repository
```

> **Note:** Use the SSH URL (`git@github.com:...`) if you set up SSH keys, or HTTPS URL otherwise.

### Creating a Branch for Your Changes

Always create a new branch for your review changes:

```bash
git checkout -b review/security-requirements-feedback
```

Naming conventions for branches:

- `review/topic-description` for review feedback
- `fix/issue-description` for corrections
- `update/section-name` for updates to specific sections

### Making Changes

Open the markdown file in your preferred editor and make your changes.

Check what you changed:

```bash
git status                  # Shows which files changed
git diff                    # Shows the actual changes
```

### Committing Your Changes

Stage and commit your changes with a descriptive message:

```bash
git add docs/requirements/security.md
git commit -m "Update security requirements: clarify authentication timeout"
```

Write good commit messages:

- First line: Brief summary (50 characters or less)
- Blank line
- Detailed explanation if needed (wrap at 72 characters)

### Pushing and Creating a Pull Request

Push your branch to GitHub:

```bash
git push -u origin review/security-requirements-feedback
```

GitHub will display a URL to create a pull request. You can also create it from the web interface or using the `gh` CLI (see next section).

### Keeping Your Branch Updated

If the main branch has new changes, update your branch:

```bash
git checkout main
git pull
git checkout review/security-requirements-feedback
git rebase main
```

> **Note:** If you encounter conflicts, Git will guide you through resolving them.

---

## 7. Using the GitHub CLI (gh)

The GitHub CLI (`gh`) combines Git functionality with GitHub features, letting you create issues, pull requests, and more from your terminal.

### Installing the GitHub CLI

#### Windows

```bash
winget install GitHub.cli
```

Or download from https://cli.github.com

#### macOS

```bash
brew install gh
```

#### Linux (Debian/Ubuntu)

```bash
sudo apt install gh
```

Or use the official repository:

```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

### Authenticating with GitHub

```bash
gh auth login
```

Follow the prompts to authenticate via browser or token.

### Creating Pull Requests with gh

After committing your changes locally:

```bash
gh pr create --title "Update security requirements" --body "Clarified authentication timeout requirements per discussion in issue #42"
```

Interactive mode (will prompt for details):

```bash
gh pr create
```

### Reviewing Pull Requests with gh

List open pull requests:

```bash
gh pr list
```

View a specific pull request:

```bash
gh pr view 123              # View PR #123
gh pr view 123 --web        # Open in browser
```

Check out a PR locally for review:

```bash
gh pr checkout 123
```

Add a review:

```bash
gh pr review 123 --approve
gh pr review 123 --request-changes --body "Please clarify the timeout value"
gh pr review 123 --comment --body "Looks good overall"
```

### Working with Issues

Create a new issue:

```bash
gh issue create --title "Question about requirement 3.2" --body "The current wording is ambiguous..."
```

List issues:

```bash
gh issue list
gh issue list --label "needs-review"
```

View and comment on issues:

```bash
gh issue view 45
gh issue comment 45 --body "I agree with this assessment"
```

### Useful gh Commands Summary

| Command | Description |
|---------|-------------|
| `gh repo clone org/repo` | Clone a repository |
| `gh pr create` | Create a pull request |
| `gh pr list` | List open pull requests |
| `gh pr checkout <number>` | Check out a PR locally |
| `gh pr view <number>` | View pull request details |
| `gh pr review <number>` | Submit a review |
| `gh pr merge <number>` | Merge a pull request |
| `gh issue create` | Create an issue |
| `gh issue list` | List issues |
| `gh issue view <number>` | View issue details |
| `gh issue comment <number>` | Comment on an issue |
| `gh browse` | Open repo in browser |

---

## 8. Best Practices for Document Reviews

### Writing Effective Comments

- **Be specific:** Reference line numbers or quote the text you're addressing
- **Be constructive:** Explain why something should change, not just that it should
- **Suggest alternatives:** When pointing out issues, propose solutions
- **Distinguish severity:** Indicate if something is a blocking issue or a suggestion

### Structuring Pull Requests

- **One topic per PR:** Don't mix unrelated changes
- **Keep PRs small:** Smaller changes are easier to review and merge
- **Link to issues:** Reference related issues using `#issue-number`
- **Describe your changes:** Help reviewers understand your intent

### Markdown Tips for Requirements Documents

Use consistent formatting:

```markdown
# Main Heading
## Section
### Subsection

**Bold** for emphasis
*Italic* for definitions
`code` for technical terms

- Bullet points for lists
1. Numbered lists for sequences
```

Use tables for structured data:

```markdown
| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-001        | ...         | High     |
```

### Communication Guidelines

- **Respond promptly:** Try to address review feedback within 24-48 hours
- **Use @mentions:** Notify specific people when you need their input
- **Resolve conversations:** Mark discussions as resolved when addressed
- **Be professional:** Remember that comments are permanent and visible to all

---

## 9. Quick Reference

### Common Git Commands

| Command | Description |
|---------|-------------|
| `git clone <url>` | Copy a repository to your computer |
| `git status` | Show changed files |
| `git diff` | Show changes in detail |
| `git checkout -b <branch>` | Create and switch to a new branch |
| `git checkout <branch>` | Switch to an existing branch |
| `git add <file>` | Stage changes for commit |
| `git add .` | Stage all changes |
| `git commit -m "msg"` | Commit staged changes |
| `git push` | Upload commits to GitHub |
| `git push -u origin <branch>` | Push a new branch to GitHub |
| `git pull` | Download and merge remote changes |
| `git fetch` | Download remote changes without merging |
| `git log --oneline` | View commit history |
| `git stash` | Temporarily save uncommitted changes |
| `git stash pop` | Restore stashed changes |

### Keyboard Shortcuts (GitHub Web)

| Shortcut | Action |
|----------|--------|
| `t` | Activate file finder |
| `w` | Switch branches |
| `l` | Jump to a line |
| `e` | Edit file |
| `.` | Open in github.dev editor |
| `g` `n` | Go to notifications |
| `g` `c` | Go to code tab |
| `g` `i` | Go to issues tab |
| `g` `p` | Go to pull requests tab |
| `?` | Show all shortcuts |

### Getting Help

- **GitHub Documentation:** https://docs.github.com
- **Git Documentation:** https://git-scm.com/doc
- **GitHub CLI Manual:** https://cli.github.com/manual
- **In terminal:** `git help <command>` or `gh help <command>`

---

*This guide was created to help technical professionals effectively review requirements documents using GitHub. For questions or feedback, please contact your team lead or submit an issue to the documentation repository.*
