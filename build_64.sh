PATH=$PATH:.
set -e # Exit immediately if a command exits with a non-zero status.

petra_tools_home=$(pwd)
petra_tools_source_dir=$petra_tools_home/src
petra_tools_install_dir=$petra_tools_home/install
petra_tools_include_dir=$petra_tools_home/include
petra_tools_library_dir=$petra_tools_home/lib
installed_objects_hidden_dir=$petra_tools_home/.objs


[[ ! -d $petra_tools_source_dir ]] && mkdir $petra_tools_source_dir
[[ ! -d $petra_tools_install_dir ]] && mkdir $petra_tools_install_dir
[[ ! -d $petra_tools_include_dir ]] && mkdir $petra_tools_include_dir
[[ ! -d $petra_tools_library_dir ]] && mkdir $petra_tools_library_dir

download_package(){
    local package_name=$1
    local package_download_url=$2\
    
    wget --force-directories -O package.tar.gz $package_download_url
    
    local unzip_dir=$(tar tf package.tar.gz | head -1)
    tar xvf package.tar.gz
    [[ -f "package.tar.gz" ]] && rm -rf package.tar.gz
    [[ -d $petra_tools_source_dir/$package_name ]] && rm -rf $petra_tools_source_dir/$package_name
    mv $unzip_dir $petra_tools_source_dir/$package_name
}


#
# Install openssl package library
#
install_package_openssl(){
    cd $petra_tools_home
    
    local package_version=0_9_8i
    local package_name=openssl-$package_version

    if [ -d $petra_tools_install_dir/$package_name ]; then
        echo "The '$package_name' package has already been installed."
        echo ""
        return
    fi
    
    download_package $package_name https://github.com/openssl/openssl/archive/refs/tags/OpenSSL_$package_version.tar.gz
    cd $petra_tools_source_dir/$package_name
    
    # openssl 0.9.8i config options
    Configure no-asm no-krb5 no-zlib shared threads linux-x86_64 --prefix=$petra_tools_install_dir/$package_name
    # no-asm: Does not use assembly language that is dependent on a specific CPU architecture, such as Intel or AMD."
    # no-zlib: Does not use zlib related functions such as EVP_zlib, COMP_zlib.
    # no-krb5: Disables Kerberos 5 protocol functions such as krb5_c_random_make_octets, krb5_encrypt, and krb5_decrypt.
    # no-shared -fPIC: "It does not create a .so dynamic library, but compiles the objects using the Position Independent Code option.
    # threads: Enables multithreading support.
    # linux-x86_64: Specifies the target platform.
    
    make
    make install_sw
    
    ln -sf $petra_tools_install_dir/$package_name/include/* $petra_tools_include_dir
}

#
# Install zlib package library
#
install_package_zlib(){
    cd $petra_tools_home
    
    local package_version=1.2.3
    local package_name=zlib-$package_version
    
    if [ -d $petra_tools_install_dir/$package_name ]; then
        echo "The '$package_name' package has already been installed."
        echo ""
        return
    fi
    
    download_package $package_name https://github.com/madler/zlib/archive/refs/tags/v$package_version.tar.gz
    cd $petra_tools_source_dir/$package_name
    
    # Zlib does not explicitly accept the '-fPIC' option in its configure script.
    # To use this option, it must be assigned to the CFLAGS environment variable.
    # Using the '--shared' option with configure applies the -fPIC option, but this option does not generate the zlib.a static library.
    export CFLAGS="-fPIC"
    configure --prefix=$petra_tools_install_dir/$package_name
    unset CFLAGS
    
    make
    make install
    
    ln -sf $petra_tools_install_dir/$package_name/include/* $petra_tools_include_dir
}

#
# Install esmtp package library
#
install_package_esmtp(){
    cd $petra_tools_home
    
    local package_version=1.0.6
    local package_name=esmtp-$package_version

    if [ -d $petra_tools_install_dir/$package_name ]; then
        echo "The '$package_name' package has already been installed."
        echo ""
        return
    fi
    
    download_package $package_name https://github.com/libesmtp/libESMTP/archive/refs/tags/v$package_version.tar.gz
    cd $petra_tools_source_dir/$package_name
    
    [[ ! -d "m4" ]] && mkdir m4
    autoreconf --install --force
    configure --prefix=$petra_tools_install_dir/$package_name \
    --enable-shared=no \
    --enable-static=yes \
    --with-pic \
    --enable-pthreads \
    --without-openssl
    # --without-openssl: Disables security features related to email transmission such as STARTTLS, SMTP, and SSL_CTX.
    
    make
    make install
    
    ln -sf $petra_tools_install_dir/$package_name/include/* $petra_tools_include_dir
}

#
# Install curl package library
#
install_package_curl(){
    cd $petra_tools_home
    
    local package_version=7_40_0
    local package_name=curl-$package_version

    if [ -d $petra_tools_install_dir/$package_name ]; then
        echo "The '$package_name' package has already been installed."
        echo ""
        return
    fi
    
    download_package $package_name https://github.com/curl/curl/archive/refs/tags/curl-$package_version.tar.gz
    cd $petra_tools_source_dir/$package_name
    
    [[ ! -d "m4" ]] && mkdir m4
    autoreconf --install --force
    
    configure --prefix=$petra_tools_install_dir/$package_name \
    --enable-shared=no  \
    --enable-static=yes \
    --with-pic \
    --disable-hidden-symbols \
    --disable-versioned-symbols \
    --enable-http \
    --disable-ftp \
    --disable-file \
    --disable-ldap \
    --disable-ldaps \
    --disable-rtsp \
    --disable-proxy \
    --disable-dict \
    --disable-telnet \
    --disable-tftp \
    --disable-pop3 \
    --disable-imap \
    --disable-smb \
    --disable-smtp \
    --disable-gopher \
    --disable-ipv6 \
    --disable-verbose \
    --disable-sspi \
    --disable-crypto-auth \
    --disable-ntlm-wb \
    --disable-tls-srp \
    --disable-unix-sockets \
    --disable-cookies \
    --disable-soname-bump \
    --without-zlib \
    --without-winssl \
    --without-darwinssl \
    --without-ssl \
    --without-gnutls \
    --without-polarssl \
    --without-cyassl \
    --without-nss \
    --without-axtls \
    --without-ca-bundle \
    --without-ca-path \
    --without-libmetalink \
    --without-libssh2 \
    --without-librtmp \
    --without-winidn \
    --without-libidn \
    --without-nghttp2
    # Using only the HTTP feature from the external Curl package. (--enable-http)
    
    make
    make install
    
    ln -sf $petra_tools_install_dir/$package_name/include/* $petra_tools_include_dir
}

#
# Install pcap package library
#
install_package_pcap(){
    cd $petra_tools_home
    
    local package_version=0.9.4
    local package_name=pcap-$package_version

    if [ -d $petra_tools_install_dir/$package_name ]; then
        echo "The '$package_name' package has already been installed."
        echo ""
        return
    fi
    
    download_package $package_name https://github.com/the-tcpdump-group/libpcap/archive/refs/tags/libpcap-$package_version.tar.gz
    cd $petra_tools_source_dir/$package_name
    
    export CFLAGS="-fPIC"
    configure --prefix=$petra_tools_install_dir/$package_name
    unset CFLAGS
    
    make
    make install
    
    ln -sf $petra_tools_install_dir/$package_name/include/* $petra_tools_include_dir
}

#
# Install iconv package library
#
install_package_iconv(){
    cd $petra_tools_home
    
    local package_version=1.11
    local package_name=iconv-$package_version

    if [ -d $petra_tools_install_dir/$package_name ]; then
        echo "The '$package_name' package has already been installed."
        echo ""
        return
    fi
    
    download_package $package_name ftp://ftp.gnu.org/pub/gnu/libiconv/libiconv-$package_version.tar.gz
    cd $petra_tools_source_dir/$package_name
    
    configure --prefix=$petra_tools_install_dir/$package_name \
    --enable-shared=no \
    --enable-static=yes \
    --with-pic    
    
    make
    make install
    
    ln -sf $petra_tools_install_dir/$package_name/include/* $petra_tools_include_dir
}

#
# Install chardet package library
#
install_package_chardet(){
    cd $petra_tools_home
    
    local package_version=1.0.1
    local package_name=chardet-$package_version

    if [ -d $petra_tools_install_dir/$package_name ]; then
        echo "The '$package_name' package has already been installed."
        echo ""
        return
    fi
    
    download_package $package_name https://github.com/Joungkyun/libchardet/archive/refs/tags/$package_version.tar.gz
    cd $petra_tools_source_dir/$package_name
    
    configure --prefix=$petra_tools_install_dir/$package_name \
    --enable-shared=no \
    --enable-static=yes \
    --with-pic
    
    make
    make install
    
    ln -sf $petra_tools_install_dir/$package_name/include/* $petra_tools_include_dir
}

install_package() {
    install_package_openssl
    install_package_zlib
    install_package_esmtp
    install_package_curl
    install_package_pcap
    install_package_iconv
    install_package_chardet
}

extracted_installed_objects(){
    [[ -d "$installed_objects_hidden_dir" ]] && rm -rf $installed_objects_hidden_dir
    mkdir $installed_objects_hidden_dir
    cd $installed_objects_hidden_dir
    
    local installed_package_list=$(ls $petra_tools_install_dir)
    for installed_package in $installed_package_list
    do
        local installed_static_library_list=$(ls $petra_tools_install_dir/$installed_package/lib/*.a)
        for installed_static_library in $installed_static_library_list
        do
            ar -x $installed_static_library
            echo "The objects from archive \"$installed_static_library\" have been extracted."
        done
    done
}

make_tools_static_library() {
    local static_library_name=libtoolsst.a
    
    cd $installed_objects_hidden_dir
    
    ar -cr $static_library_name *.o
    echo "The static library \"$static_library_name\" has been created."
    
    mv $static_library_name $petra_tools_library_dir
}

make_tools_shared_library(){
    local shared_library_name=libtools.so
    
    cd $installed_objects_hidden_dir
    
    #symbol_scripts_path=../white_list_symbols.ld
    symbol_scripts_path=../black_list_symbols.ld
    
    gcc -o libtools.so *.o -shared -lstdc++ -ldl -lpthread -lrt -Wl,--version-script=$symbol_scripts_path
    # The ESMTP package requires the dl and pthread libraries. (-ldl -lpthread)
    # The curl package requires the rt library. (-lrt)
    
    echo "The shared library \"$shared_library_name\" has been created."
    
    mv $shared_library_name $petra_tools_library_dir
}

make_libraries(){
    extracted_installed_objects
    make_tools_static_library
    make_tools_shared_library
}

install_package
make_libraries
