[[ -d "src" ]] && rm -rf src
[[ -d "install" ]] && rm -rf install
[[ -d "include" ]] && rm -rf include
[[ $(ls *tar.gz | wc -l) -ge "1" ]] && rm -rf *.tar.gz
