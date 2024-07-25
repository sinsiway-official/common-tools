#!/bin/bash

config_file="setting.properties"
eval `awk -F= '{print $1"="$2}' $config_file`

if [ -z "$soha_source_dir" ] || [ -z "$tools_install_dir" ]; then
    echo "Both source and destination directories must be specified ... FAILED"
    return 1
fi

if [ ! -d "$soha_source_dir" ]; then
    echo "Source directory '$soha_source_dir' does not exist ... FAILED"
    return 1
fi

mkdir -p $tools_install_dir/include
mkdir -p $tools_install_dir/lib

cp $soha_source_dir/tools/libtools* $tools_install_dir/lib

soha_tools_install_dir=$soha_source_dir/tools/install
tools_header_dirs="libesmtp-1.0.4 libchardet-1.0.1 libpcap-0.9.4  openssl-0.9.8i zlib-1.2.3"

# Copy header files from source to installation directory
echo "Starting to copy header files..."
for header_dir in $tools_header_dirs; do
    if [ -d "$soha_tools_install_dir/$header_dir" ]; then
        cp -Rf $soha_tools_install_dir/$header_dir/include/* $tools_install_dir/include
        echo "Copied headers from '$header_dir' ...  OK"
    else
        echo "Directory '$header_dir' does not exist, skipping ... FAILED"
    fi
done

# special case for curl-7.40.0
if [ -d "$soha_tools_install_dir/curl-7.40.0/include" ]; then
    cp -Rf $soha_tools_install_dir/curl-7.40.0/include/curl/* $tools_install_dir/include
    echo "Copied headers from 'curl-7.40.0' ...  OK"
else
    echo "Directory 'curl-7.40.0' does not exist, skipping ... FAILED"
fi

# special case for readline-5.2
if [ -d "$soha_tools_install_dir/readline-5.2/include" ]; then
    cp -Rf $soha_tools_install_dir/readline-5.2/include/readline/* $tools_install_dir/include
    echo "Copied headers from 'readline-5.2' ...  OK"
else
    echo "Directory 'readline-5.2' does not exist, skipping ... FAILED"
fi

# special case for libiconv-1.11
if [ -d "$soha_tools_install_dir/libiconv-1.11/include" ]; then
    mkdir -p $tools_install_dir/include/iconv
    cp -Rf $soha_tools_install_dir/libiconv-1.11/include/* $tools_install_dir/include/iconv
    echo "Copied headers from 'libiconv-1.11' ...  OK"
else
    echo "Directory 'libiconv-1.11' does not exist, skipping ... FAILED"
fi

echo "Header installation completed."
