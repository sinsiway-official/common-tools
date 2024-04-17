# Project Installation Scripts

This repository contains a set of scripts designed to automate the installation processes for different operating systems. Each directory in the repository is tailored for specific system requirements and installation methods. Below is a description of each directory:

## Directories

### `build_install_linux`

This directory includes scripts for building and installing all necessary packages and libraries on Linux systems. It is intended for situations where a fresh setup and installation are required.

### `copy_install_solaris`

Scripts in this directory are designed to handle installations on Unix systems by copying from an existing 'petra release' build environment. This method is suitable for systems where the environment is pre-built and only needs to be deployed.

### `copy_install_unix_linux`

This directory contains scripts optimized for older versions of bash, specifically for Solaris servers. These scripts perform simple installation tasks, making them ideal for environments with limited bash functionality.

## Usage

To use these scripts, navigate to the respective directory based on your operating system and requirements. Each directory contains a detailed `README.md` with instructions on how to execute the scripts properly.

Ensure that you have the necessary permissions to execute the scripts and that your system meets all prerequisites as described in the individual `README.md` files in each directory.

## Contributing

Contributions to improve the scripts or add new features are welcome. Please fork the repository, make your changes, and submit a pull request. Ensure your contributions are well-documented and adhere to the existing coding standards.

## License

Copyright 2024 Sinsiway. All Rights Reserved.