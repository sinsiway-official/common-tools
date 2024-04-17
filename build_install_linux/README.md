# build_install_linux

This directory contains the `build_and_install_64.sh` script designed to automate the process of building and installing essential software packages and libraries necessary for your projects on Linux systems. The script supports multiple packages including OpenSSL, zlib, ESMTP, cURL, pcap, iconv, and chardet.

## Overview

The script sets up a complete environment within the current working directory, handles the downloading of source packages, builds them, and then installs them. It organizes the installed files into structured directories and creates both static and shared versions of the libraries.

## Prerequisites

- **Linux OS (x86_64 architecture)**
- **Wget**: For downloading package archives.
- **Tar**: For extracting package archives.
- **GNU Compiler Collection (GCC)**: For compiling the packages.
- **Make**: For automating the build process.
- **Autoconf and Automake**: Needed for generating configuration scripts and Makefile.in files from Makefile.am.
- **Ar (part of the binutils package)**: For extracting and creating archives from static libraries.
- **Libtool**: For managing static and shared libraries.

Ensure these tools are installed on your system before running the script. You can install them using your system's package manager. For example, on Ubuntu or Debian:

bashCopy code

`sudo apt-get update sudo apt-get install wget tar gcc make autoconf automake libtool binutils`

## Usage

To use the script, navigate to this directory in your terminal and execute the script with the desired destination directory for the installed libraries and headers:

bashCopy code

`./build_and_install_64.sh -dest /public/tools`

### Packages and Versions

The script installs the following specific versions of libraries:

- **OpenSSL**: Version 0.9.8i
- **zlib**: Version 1.2.3
- **ESMTP**: Version 1.0.6
- **cURL**: Version 7.40.0
- **pcap**: Version 0.9.4
- **iconv**: Version 1.11
- **chardet**: Version 1.0.1

### Important Note

- **Modify `target_tools_dir`**: Before running the script, ensure that the `target_tools_dir` is correctly specified either directly within the script or through the command line using the `-dest` option. This directory is where all the libraries and headers will be installed.

## Features

- **Comprehensive Installation**: Automates the downloading, configuration, building, and installation of several critical libraries.
- **Flexible Configuration Options**: Each package is configured with options suited for typical use cases, ensuring compatibility and optimization.
- **Error Handling**: The script includes error checks and exits immediately if any command fails (`set -e`), which helps in identifying issues during the installation process.

## Troubleshooting

If you encounter issues during the installation:

- Check the permissions of the script with `ls -l build_and_install_64.sh` and ensure it is executable. If not, run `chmod +x build_and_install_64.sh`.
- Ensure all prerequisites are properly installed.
- Verify network connectivity for downloading packages.
- Check the output logs for any specific errors related to configuration or compilation steps.

For any specific package issues, refer to the official documentation or support forums of the respective package.