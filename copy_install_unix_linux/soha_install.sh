soha_source_dir=""
soha_install_dir=""
versioned_soha_install_dir=""
soha_relese_version=""
soha_patch_version=""

display_help() {
    echo "Usage: $(basename $0) [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -s, --src [source_dir]    Specify the source directory where the files are located."
    echo "  -d, --dest [install_dir]  Specify the destination directory where the files should be installed."
    echo ""
    echo "Example:"
    echo "  $(basename $0) --src /path/to/source --dest /path/to/destination"
    echo "  $(basename $0) -s /path/to/source -dt /path/to/destination"
    echo ""
    echo "This script assigns the provided source and destination directories to global variables."
    echo "Make sure that both directories exist before calling the script."
}

assign_directories() {
    local src_dir=""
    local dest_dir=""

    # Check if no options were provided
    if [ "$#" -eq 0 ]; then
        display_help
        return 1 # Exit the function with an error code
    fi

    # Parse command-line options
    while [ "$#" -gt 0 ]; do
        case "$1" in
        -s | --src)
            src_dir="$2"
            shift 2 # Move past the argument value
            ;;
        -d | --dest)
            dest_dir="$2"
            shift 2 # Move past the argument value
            ;;
        *)
            echo "Unknown option: $1"
            display_help
            return 1 # Return with error code
            ;;
        esac
    done

    # Check if both directories have been specified
    if [ -z "$src_dir" ] || [ -z "$dest_dir" ]; then
        echo "Both source and destination directories must be specified ... FAILED"
        display_help
        return 1
    fi

    # Check if the source directory exists
    if [ ! -d "$src_dir" ]; then
        echo "Source directory '$src_dir' does not exist ... FAILED"
        return 1 # Return with error code
    fi

    # Check if the install directory exists
    # if [ -d "$dest_dir" ]; then
    #     echo "Error: Install directory '$dest_dir' already exists."
    #     return 1 # Return with error code
    # fi

    # Assign the directories to the global variables
    soha_source_dir="$src_dir"
    soha_install_dir="$dest_dir"

    echo "Directories assigned successfully."
    echo "Source directory: $soha_source_dir"
    echo "Install directory: $soha_install_dir"
}

#!/bin/bash

# This function extracts release and patch version numbers from a specified file and assigns them to variables.
extract_versions() {
    local version_file="$soha_source_dir/dist/mkenv"

    # Check if the file exists
    if [ ! -f "$version_file" ]; then
        echo "Error: Version file does not exist."
        return 1 # Exit the function with an error code
    fi

    # Extract release and patch versions
    local release_version=$(grep '^release_version=' "$version_file" | cut -d '=' -f2)
    local patch_version=$(grep '^patch_version=' "$version_file" | cut -d '=' -f2)

    # Check if the values are extracted successfully
    if [ -z "$release_version" ] || [ -z "$patch_version" ]; then
        echo "Failed to extract version numbers ... FAILED"
        return 1 # Exit the function with an error code
    fi

    # Assign the values to global variables
    soha_release_version=$release_version
    soha_patch_version=$patch_version
    versioned_soha_install_dir="${soha_install_dir}.${soha_release_version}.${soha_patch_version}"

    if [ -d "$versioned_soha_install_dir" ]; then
        echo "Versioned install directory '$versioned_soha_install_dir' already exists ... FAILED"
        return 1 # Exit the function with an error code
    fi

    echo "Release version: $soha_release_version"
    echo "Patch version: $soha_patch_version"
}

# Example of how to call the function
# extract_versions

# This function checks if specific library files exist in the $soha_source_dir/lib directory
# and copies them, adjusting for OS-specific library extensions for shared libraries, to the $soha_install_dir/lib directory.
# It automatically detects the operating system and architecture.
install_library_files() {
    local os_type="$(uname -s)"
    local arch_type="$(uname -m)"
    local lib_dir="${soha_source_dir}/lib"
    local install_lib_dir="${soha_install_dir}/lib"
    local shared_files="libpetra libextproc"
    local static_files="libpetrast libextprocst"
    local found_files=0
    local shared_extension=""
    local static_extension="a"

    # Determine the correct library extension for shared libraries based on OS and architecture
    case "$os_type" in
    "Linux" | "SunOS" | "AIX")
        shared_extension="so"
        ;;
    "HP-UX")
        if [[ "$arch_type" = *"ia64"* ]]; then
            shared_extension="so" # IA64 uses .so
        else
            shared_extension="sl" # PA-RISC uses .sl
        fi
        ;;
    *)
        echo "Unsupported OS type: $os_type"
        return 1
        ;;
    esac

    # Check each shared library file in the list
    for base_name in ${shared_files}; do
        local full_file_name="${base_name}.${shared_extension}"
        if [ -f "${lib_dir}/${full_file_name}" ]; then
            echo "shared library ${full_file_name} found in ${lib_dir} ... OK"
            found_files=$((found_files + 1))
        fi
    done

    # Check each static library file in the list
    for base_name in ${static_files}; do
        local full_file_name="${base_name}.${static_extension}"
        if [ -f "${lib_dir}/${full_file_name}" ]; then
            echo "static library ${full_file_name} found in ${lib_dir} ... OK"
            found_files=$((found_files + 1))
        fi
    done

    # If any file is missing, exit the script
    if [ "$found_files" -lt 4 ]; then
        echo "Not all required library files are present. Exiting ... FAILED"
        return 1
    else
        echo "All required library files are present."
        # Ensure the install directory exists
        versioned_soha_install_lib_dir=${versioned_soha_install_dir}/lib
        mkdir -p "$versioned_soha_install_lib_dir"
        # Copy the library files to the installation directory
        echo "Copying library files to $versioned_soha_install_lib_dir..."
        for base_name in ${shared_files}; do
            local full_file_name="${base_name}.${shared_extension}"
            cp -f "${lib_dir}/${full_file_name}" "${versioned_soha_install_lib_dir}/${full_file_name}"
            echo "${file_versioned} copied ... OK"
        done
        for base_name in ${static_files}; do
            local full_file_name="${base_name}.${static_extension}"
            cp -f "${lib_dir}/${full_file_name}" "${versioned_soha_install_lib_dir}/${full_file_name}"
            echo "${file_versioned} copied ... OK"
        done
        echo "All files have been successfully copied."
    fi
}

# This function copies header files from the source directory to the install directory and prints the progress.
install_soha_headers() {
    local soha_install_include_dir="$versioned_soha_install_dir/include"
    local soha_source_lib_dir="$soha_source_dir/lib"
    # Define the list of directories containing header files
    local soha_header_dirs="common dbif dic extproc ldb misc/clib misc/mm misc/host net npas parser parser/mysql parser/tds parser/postgre parser/udb parser/oracle pdb petra petra/access petra/cipher petra/primon petra/ceea"

    # Ensure the installation directory exists
    mkdir -p "$soha_install_include_dir"

    # Copy header files from source to installation directory
    echo "Starting to copy header files..."
    for header_dir in $soha_header_dirs; do
        if [ -d "$soha_source_lib_dir/$header_dir" ]; then
            cp -f $soha_source_lib_dir/$header_dir/*.h $soha_install_include_dir
            echo "Copied headers from '$header_dir' ...  OK"
        else
            echo "Directory '$header_dir' does not exist, skipping ... FAILED"
        fi
    done

    # Modify specific header file
    if [ -f "$soha_install_include_dir/PtCharConv.h" ]; then
        sed 's/iconv\/iconv.h/iconv.h/g' $soha_install_include_dir/PtCharConv.h >$soha_install_include_dir/PtCharConv.h.tmp && mv $soha_install_include_dir/PtCharConv.h.tmp $soha_install_include_dir/PtCharConv.h
        echo "Modified 'PtCharConv.h' for iconv path correction ... OK"
    else
        echo "'PtCharConv.h' does not exist, skipping modification ... FAILED"
    fi

    #
    if [ -f "$soha_source_dir/build/config.h" ]; then
        cp -f $soha_source_dir/build/config.h $soha_install_include_dir
        echo "Copied 'config.h' ... OK"
    else
        echo "'build/config.h' does not exist, skipping modification ... FAILED"
    fi

    # Copy additional config and DB interface directories
    echo "Copying additional configuration and DB interface directories..."
    local db_interfaces="goldilocks informix cubrid_v9.1 db2_v9.5 tibero altibase teradata sybase mysql hanadb postgres"
    for dbif in ${db_interfaces}; do
        mkdir -p $soha_install_include_dir/${dbif%_*}
        if [ -d "$soha_source_lib_dir/dbif/$dbif" ]; then
            cp -R $soha_source_lib_dir/dbif/$dbif/*.h $soha_install_include_dir/${dbif%_*}
            echo "Copied '$dbif' ... OK"
        else
            echo "DB interface directory '$dbif' does not exist, skipping ... FAILED"
            return 1
        fi
    done

    # oci10 is a special case
    if [ -d "$soha_source_lib_dir/dbif/oci10" ]; then
        mkdir -p $soha_install_include_dir/oci
        cp -R $soha_source_lib_dir/dbif/oci10/*.h $soha_install_include_dir/oci
        echo "Copied 'oci10' ... OK"
    else
        echo "DB interface directory 'oci10' does not exist, skipping ... FAILED"
        return 1
    fi

    echo "Header installation completed."
}

main() {
    # Assign the directories
    assign_directories "$@" || return 1

    extract_versions || return 1

    install_library_files || return 1

    install_soha_headers || return 1

    ln -sf "$versioned_soha_install_dir" "$soha_install_dir"

    # Copy the source directory to the install directory
    # cp -r "$soha_source_dir" "$soha_install_dir" || return 1

    echo "Installation completed successfully."
}

main "$@"
