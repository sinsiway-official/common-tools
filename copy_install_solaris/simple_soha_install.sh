#!/bin/bash

config_file="setting.properties"
eval $(awk -F= '{print $1"="$2}' $config_file)

if [ -z "$soha_source_dir" ] || [ -z "$soha_tools_install_dir" ]; then
    echo "Both source and destination directories must be specified ... FAILED"
    return 1
fi

if [ ! -d "$soha_source_dir" ]; then
    echo "Source directory '$soha_source_dir' does not exist ... FAILED"
    return 1
fi

mkdir -p $soha_tools_install_dir/include
mkdir -p $soha_tools_install_dir/lib

cp $soha_source_dir/lib/libpetra* $soha_tools_install_dir/lib
cp $soha_source_dir/lib/libextproc* $soha_tools_install_dir/lib

soha_header_dirs="common dbif dic extproc ldb misc/clib misc/mm misc/host net npas parser parser/mysql parser/tds parser/postgre parser/udb parser/oracle pdb petra petra/access petra/cipher petra/primon petra/ceea"
for header_dir in $soha_header_dirs; do
    if [ -d "$soha_source_dir/lib/$header_dir" ]; then
        cp -f $soha_source_dir/lib/$header_dir/*.h $soha_tools_install_dir/include
    fi
done

if [ -f "$soha_tools_install_dir/include/PtCharConv.h" ]; then
    sed 's/iconv\/iconv.h/iconv.h/g' $soha_tools_install_dir/include/PtCharConv.h >$soha_tools_install_dir/include/PtCharConv.h.tmp && mv $soha_tools_install_dir/include/PtCharConv.h.tmp $soha_tools_install_dir/include/PtCharConv.h
    echo "Modified 'PtCharConv.h' for iconv path correction ... OK"
else
    echo "'PtCharConv.h' does not exist, skipping modification ... FAILED"
fi

if [ -f "$soha_source_dir/build/config.h" ]; then
    cp -f $soha_source_dir/build/config.h $soha_tools_install_dir/include
    echo "Copied 'config.h' ... OK"
else
    echo "'build/config.h' does not exist, skipping modification ... FAILED"
fi

mkdir -p $soha_tools_install_dir/include/oci
mkdir -p $soha_tools_install_dir/include/goldilocks
mkdir -p $soha_tools_install_dir/include/informix
mkdir -p $soha_tools_install_dir/include/cubrid
mkdir -p $soha_tools_install_dir/include/db2
mkdir -p $soha_tools_install_dir/include/tibero
mkdir -p $soha_tools_install_dir/include/altibase
mkdir -p $soha_tools_install_dir/include/teradata
mkdir -p $soha_tools_install_dir/include/sybase
mkdir -p $soha_tools_install_dir/include/mysql
mkdir -p $soha_tools_install_dir/include/hanadb
mkdir -p $soha_tools_install_dir/include/postgres

cp -R $soha_source_dir/lib/dbif/oci10/*.h $soha_tools_install_dir/include/oci
cp -R $soha_source_dir/lib/dbif/goldilocks/*.h $soha_tools_install_dir/include/goldilocks
cp -R $soha_source_dir/lib/dbif/informix/*.h $soha_tools_install_dir/include/informix
cp -R $soha_source_dir/lib/dbif/cubrid_v9.1/*.h $soha_tools_install_dir/include/cubrid
cp -R $soha_source_dir/lib/dbif/db2_v9.5/*.h $soha_tools_install_dir/include/db2
cp -R $soha_source_dir/lib/dbif/tibero/*.h $soha_tools_install_dir/include/tibero
cp -R $soha_source_dir/lib/dbif/altibase/*.h $soha_tools_install_dir/include/altibase
cp -R $soha_source_dir/lib/dbif/teradata/*.h $soha_tools_install_dir/include/teradata
cp -R $soha_source_dir/lib/dbif/sybase/*.h $soha_tools_install_dir/include/sybase
cp -R $soha_source_dir/lib/dbif/mysql/*.h $soha_tools_install_dir/include/mysql
cp -R $soha_source_dir/lib/dbif/hanadb/*.h $soha_tools_install_dir/include/hanadb
cp -R $soha_source_dir/lib/dbif/postgres/*.h $soha_tools_install_dir/include/postgres

echo "Header installation completed."
