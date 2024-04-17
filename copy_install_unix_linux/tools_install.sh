soha_source_dir=""
tools_install_dir=""

display_help() {
    echo "Usage: $(basename $0) [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -s, --src [source_dir]    Specify the source directory where the files are located."
    echo "  -d, --dest [install_dir]  Specify the destination directory where the files should be installed."
    echo ""
    echo "Example:"
    echo "  $(basename $0) --src /path/to/source --dest /path/to/destination"
    echo "  $(basename $0) -s /path/to/source -d /path/to/destination"
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
    if [ -d "$dest_dir" ]; then
        echo "Error: Install directory '$dest_dir' already exists."
        return 1 # Return with error code
    fi

    # Assign the directories to the global variables
    soha_source_dir="$src_dir"
    tools_install_dir="$dest_dir"

    echo "Directories assigned successfully."
    echo "Source directory: $soha_source_dir"
    echo "Install directory: $tools_install_dir"
}

# This function checks if specific library files exist in the $soha_source_dir/lib directory
# and copies them, adjusting for OS-specific library extensions for shared libraries, to the $tools_install_dir/lib directory.
# It automatically detects the operating system and architecture.
install_library_files() {
    local os_type=$(uname -s)
    local arch_type=$(uname -m)
    local lib_dir="${soha_source_dir}/tools"
    local install_lib_dir="${tools_install_dir}/lib"
    local shared_files="libtools"
    local static_files="libtoolsst"
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
        else
            echo "shared library '${full_file_name}' not found in ${lib_dir} ... FAILED"
        fi
    done

    # Check each static library file in the list
    for base_name in ${static_files}; do
        local full_file_name="${base_name}.${static_extension}"
        if [ -f "${lib_dir}/${full_file_name}" ]; then
            echo "static library ${full_file_name} found in ${lib_dir} ... OK"
            found_files=$((found_files + 1))
        else
            echo "static library '${full_file_name}' not found in ${lib_dir} ... FAILED"
        fi
    done

    # If any file is missing, exit the script
    if [ "$found_files" -lt 2 ]; then
        echo "Not all required library files are present. Exiting ... FAILED"
        return 1
    else
        echo "All required library files are present."
        # Ensure the install directory exists
        mkdir -p "$install_lib_dir"
        # Copy the library files to the installation directory
        echo "Copying library files to '$install_lib_dir' ..."
        for base_name in ${shared_files}; do
            local full_file_name="${base_name}.${shared_extension}"
            cp -f "${lib_dir}/${full_file_name}" "${install_lib_dir}/${full_file_name}"
            echo "shard library '${full_file_name}' copied ... OK"
        done
        for base_name in ${static_files}; do
            local full_file_name="${base_name}.${static_extension}"
            cp -f "${lib_dir}/${full_file_name}" "${install_lib_dir}/${full_file_name}"
            echo "static library '${full_file_name}' copied ... OK"
        done
        echo "All files have been successfully copied."
    fi
}

# This function copies header files from the source directory to the install directory and prints the progress.
install_soha_headers() {

    local soha_tools_install_dir="$soha_source_dir/tools/install"
    local tools_install_include_dir="$tools_install_dir/include"

    # Define the list of directories containing header files
    local tools_header_dirs="libesmtp-1.0.4 libchardet-1.0.1 libpcap-0.9.4  openssl-0.9.8i zlib-1.2.3"

    # Ensure the installation directory exists
    mkdir -p "$tools_install_include_dir"

    # Copy header files from source to installation directory
    echo "Starting to copy header files..."
    for header_dir in $tools_header_dirs; do
        if [ -d "$soha_tools_install_dir/$header_dir" ]; then
            cp -Rf $soha_tools_install_dir/$header_dir/include/* $tools_install_include_dir
            echo "Copied headers from '$header_dir' ...  OK"
        else
            echo "Directory '$header_dir' does not exist, skipping ... FAILED"
        fi
    done

    # special case for curl-7.40.0
    if [ -d "$soha_tools_install_dir/curl-7.40.0/include" ]; then
        cp -Rf $soha_tools_install_dir/curl-7.40.0/include/curl/* $tools_install_include_dir
        echo "Copied headers from 'curl-7.40.0' ...  OK"
    else
        echo "Directory 'curl-7.40.0' does not exist, skipping ... FAILED"
    fi

    # special case for readline-5.2
    if [ -d "$soha_tools_install_dir/readline-5.2/include" ]; then
        cp -Rf $soha_tools_install_dir/readline-5.2/include/readline/* $tools_install_include_dir
        echo "Copied headers from 'readline-5.2' ...  OK"
    else
        echo "Directory 'readline-5.2' does not exist, skipping ... FAILED"
    fi

    # special case for libiconv-1.11
    if [ -d "$soha_tools_install_dir/libiconv-1.11/include" ]; then
        cp -Rf $soha_tools_install_dir/libiconv-1.11/include/* $tools_install_include_dir/iconv
        echo "Copied headers from 'libiconv-1.11' ...  OK"
    else
        echo "Directory 'libiconv-1.11' does not exist, skipping ... FAILED"
    fi

    echo "Header installation completed."
}

main() {
    # Assign the directories
    assign_directories "$@" || return 1

    install_library_files || return 1

    install_soha_headers || return 1

    echo "Installation completed successfully."
}

main "$@"
