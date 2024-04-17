# copy_install_solaris

This directory contains two scripts, `simple_soha_install.sh` and `simple_tools_install.sh`, designed to facilitate the copying and installation of SOHA software and various tools into a specified destination directory on Solaris systems. Due to issues with older versions of bash in the Solaris build environment, these scripts are provided in their simplest possible versions.

## Overview

The `simple_soha_install.sh` script is responsible for setting up SOHA by copying libraries and headers from a pre-defined source directory to a destination directory tailored for Solaris systems. This approach ensures compatibility and reliability, avoiding complexities that might not be supported by older bash versions.

The `simple_tools_install.sh` script handles the installation of additional tools required by SOHA, ensuring that all necessary libraries and headers are correctly placed in the target environment.

## Prerequisites

- **Solaris OS**
- Basic command-line utilities (`cp`, `mkdir`, `echo`, `sed`, etc.)
- Pre-existing source directories containing all the necessary built binaries and headers.

## Important Notes

- **Modify `soha_source_dir`**: It is crucial to modify the `soha_source_dir` in each script to reflect the actual path where the source directories are located before running the scripts.

## Usage

### simple_soha_install.sh

This script copies SOHA libraries and headers from a specified source directory to a destination directory. It performs checks to ensure the existence of source and destination directories before proceeding.

#### Syntax

bashCopy code

`./simple_soha_install.sh`

#### Expected Directories

- **Source Directory**: Pre-set to `/data/hudson/workspace/petra4_sun_x86_64_release/b64/REL-4.1.0.1/src`
- **Destination Directory**: Pre-set to `/public/soha`

### simple_tools_install.sh

This script is used to install various tools by copying necessary libraries and headers from a SOHA-defined source directory to a tools-specific destination directory.

#### Syntax

bashCopy code

`./simple_tools_install.sh`

#### Expected Directories

- **Source Directory for Tools**: Same as SOHA source but includes specific tool subdirectories.
- **Destination Directory for Tools**: Pre-set to `/public/tools`

## Features

- **Compatibility with Older Bash**: Scripts are designed to run with older versions of bash commonly found on Solaris systems.
- **Error Handling**: Both scripts include basic error checks to prevent operations if directories are not correctly specified or do not exist.
- **Simple Installation**: Focuses on copying files without performing any complex installation processes, ensuring compatibility and ease of use on legacy systems.

## Troubleshooting

If issues occur, check the following:

- Confirm the existence of the source directories and that they contain the expected files.
- Ensure the destination directories are writable or do not already contain files that might conflict.
- Check script outputs for any error messages that might indicate what went wrong.