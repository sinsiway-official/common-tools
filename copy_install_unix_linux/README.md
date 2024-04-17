# copy_install_unix_linux

This directory contains two scripts, `soha_install.sh` and `tools_install.sh`, designed to facilitate the copying and installation of SOHA and various tools from a specified source directory to a target installation directory. These scripts are tailored for environments where installations are done from existing, version-controlled build artifacts.

## Overview

The `soha_install.sh` script handles the installation of the SOHA software, including setting up directories based on version numbers extracted from the source, and copying both binary and header files to the installation directory.

The `tools_install.sh` script focuses on the installation of supplementary tools that may be used alongside SOHA, ensuring that all necessary libraries and headers are correctly placed in the target environment.

## Prerequisites

- **Unix/Linux OS**
- Standard command-line tools (`grep`, `cut`, `uname`, `mkdir`, `cp`, etc.)
- Access to source directories with pre-built binaries and headers.

## Usage

### soha_install.sh

This script is used to install SOHA from a predefined source directory to a destination directory. It handles versioning and ensures that all components are copied correctly.

#### Syntax

bashCopy code

`./soha_install.sh -src [source_dir] -dest [install_dir]`

#### Example

bashCopy code

`./tools_install.sh -src /path/to/src -dest /public/soha`

### tools_install.sh

This script installs additional tools required by SOHA, copying necessary libraries and headers from the source to the installation directory.

#### Syntax

bashCopy code

`./tools_install.sh -src [source_dir] -dest [install_dir]`

#### Example

bashCopy code

`./tools_install.sh -src /path/to/src -dest /public/tools`

## Features

- **Dynamic version control**: Both scripts extract version details from the source and manage installations in a version-specific manner.
- **Error checking**: Extensive error handling to ensure directories exist and the necessary files are available before proceeding.
- **Environment compatibility**: Detects the operating system and adjusts file operations accordingly, especially for library extensions.

## Troubleshooting

If issues occur, ensure:

- The source and destination directories are correctly specified and accessible.
- Required permissions are available for creating directories and copying files.
- The source directory contains all expected files, especially the version files and library binaries.