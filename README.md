# OpenAV Cloud Specifications

## About OpenAV Cloud

[OpenAV Cloud](https://www.openav.cloud/) is an industry-wide initiative designed to advance cloud connectivity and API-driven innovation across the audiovisual sector.

### Goals

- **Interoperability** - Create a seamless, integrated AV ecosystem where different brands and platforms work together without proprietary constraints
- **Standardization** - Drive adoption of open standards and cloud connectivity to benefit the entire value chain, from manufacturers through integrators to end users
- **Customer Choice** - Ensure buyers have flexibility and freedom to choose across different brands while maintaining integrated experiences
- **Technical Infrastructure** - Develop read-write open APIs enabling genuine cross-platform compatibility and grant customers data export capabilities
- **Security & Trust** - Implement industry best practices for protecting customer data and privacy throughout cloud operations

## Specifications

| Specification | Version | Description |
|---------------|---------|-------------|
| [AV Device Taxonomy Guidelines](device-taxonomy/OAVC-AV-Device-Taxonomy-Guidelines.md) | 0.2 | Taxonomy of AV devices organized into categories based on their function, usage context, and technical characteristics |
| [AV Device Minimum Functionality Guidelines](min-device-functionality/OAVC-AV-Device-Minimum-Functionality-Guidelines.md) | 1.0 | Minimum functionality requirements for AV devices including device status, inventory, operations, networking, and discovery |
| [AV Device Security Guidelines](security-guidelines/OAVC-AV-Device-Security-Guidelines.md) | 1.0 | Security requirements covering firmware integrity, secure communications, authentication, data protection, and vulnerability management |

## Converting to PDF

A script is provided to convert all Markdown specification files to PDF format using [pandoc](https://pandoc.org/).

### Usage

```bash
./scripts/convert-to-pdf.sh
```

The script will:
- Recursively find all `.md` files in the specifications directory
- Convert each to PDF in the same location
- Skip any directories named `orig` (archive folders)

### Installing Pandoc

Pandoc requires a PDF engine (LaTeX distribution) to generate PDFs.

#### Windows

1. **Install pandoc:**
   ```powershell
   winget install JohnMacFarlane.Pandoc
   ```
   Or download the installer from [pandoc.org/installing.html](https://pandoc.org/installing.html)

2. **Install MiKTeX (LaTeX distribution):**
   ```powershell
   winget install MiKTeX.MiKTeX
   ```
   Or download from [miktex.org](https://miktex.org/download)

#### macOS

Using [Homebrew](https://brew.sh/):

```bash
brew install pandoc
brew install --cask mactex
```

Or for a smaller LaTeX installation:

```bash
brew install pandoc
brew install --cask basictex
```

#### Linux

**Debian/Ubuntu:**
```bash
sudo apt update
sudo apt install pandoc texlive-latex-base texlive-fonts-recommended texlive-xetex
```

**Fedora:**
```bash
sudo dnf install pandoc texlive-scheme-basic texlive-xetex
```

**Arch Linux:**
```bash
sudo pacman -S pandoc texlive-core
```
