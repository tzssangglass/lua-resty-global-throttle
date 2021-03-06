FROM openresty/openresty:stretch-fat

RUN apt-get update && \
  apt-get -yq install cpanminus build-essential libreadline-dev unzip && \
  curl -sSL https://luarocks.org/releases/luarocks-3.1.3.tar.gz -o luarocks-3.1.3.tar.gz && \
    tar zxpf luarocks-3.1.3.tar.gz && \
    cd luarocks-3.1.3 && \
    ./configure --prefix=/usr/local/openresty/luajit \
      --with-lua=/usr/local/openresty/luajit/ \
      --lua-suffix=jit \
      --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 && \
    make build && \
    make install && \
    cd ../ && \
    rm -rf luarocks-3.1.3.tar.gz && \
  curl -sSL https://raw.githubusercontent.com/openresty/openresty-devel-utils/master/lj-releng -o lj-releng && \
    chmod +x lj-releng && \
    mv lj-releng /usr/local/openresty/bin/ && \
  cpanm --notest Test::Nginx && \
  luarocks install busted && \
  luarocks install luacheck
