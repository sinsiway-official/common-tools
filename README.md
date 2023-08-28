# Petra Common Libraries Build Guide

## Overview

This document provides guidance on how to install and build the Petra Common Libraries, which include `libtools.so` and `libtoolsst.a`. These libraries encompass the following libraries and their versions:

- OpenSSL, Version: 0.9.8i
- zlib, Version: 1.2.3
- esmtp, Version: 1.0.6
- curl, Version: 7.40.0
- pcap, Version: 0.9.4
- iconv, Version: 1.11
- chardet, Version: 1.0.1

**Note**: The installation is typically performed under the `/public/tools` directory. All commands require `sudo` permissions for execution.

## Directory Structure

- `src`: The directory where source codes are stored.
- `install`: The directory where installed libraries and header files are saved.
- `include`: The directory for common header files.
- `lib`: The directory for the generated static and shared libraries.
- `.objs`: Temporary storage for object files.

## Installation and Build Procedure

> **Note**: The installation is typically performed under the `/public/tools` directory and all commands require `sudo` permissions.

1. **Create Directories**: Create the required directories if they do not exist.
 
 ```bash 
 sudo [[ ! -d $petra_tools_source_dir ]] && mkdir $petra_tools_source_dir
 ```
  
2. **Download and Install Packages**: Download and install each dependency package. For example, the function to install OpenSSL is `install_package_openssl`.
 
3. **Extract Object Files**: Extract object files from the static libraries (`.a` files) of each package.

```bash
sudo ar -x $installed_static_library
```

4. **Generate Libraries**: Create a single static and shared library from the extracted object files.

```bash
sudo ar -cr libtoolsst.a *.o  # For static library sudo gcc -o libtools.so *.o -shared  # For shared library
```

## Additional Information

- The script offers various configuration options to customize the libraries.
- Some libraries may have additional dependencies. Please refer to each library's installation guide for more information.
