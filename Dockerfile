FROM buildpack-deps:bullseye

# Check for latest version here: https://gcc.gnu.org/releases.html, https://ftpmirror.gnu.org/gcc
ENV GCC_VERSIONS="7.4.0 8.3.0 9.2.0"
RUN set -xe && \
    for VERSION in $GCC_VERSIONS; do \
      curl -fSsL "https://ftpmirror.gnu.org/gcc/gcc-$VERSION/gcc-$VERSION.tar.gz" -o /tmp/gcc-$VERSION.tar.gz && \
      mkdir /tmp/gcc-$VERSION && \
      tar -xf /tmp/gcc-$VERSION.tar.gz -C /tmp/gcc-$VERSION --strip-components=1 && \
      rm /tmp/gcc-$VERSION.tar.gz && \
      cd /tmp/gcc-$VERSION && \
      ./contrib/download_prerequisites && \
      { rm *.tar.* || true; } && \
      tmpdir="$(mktemp -d)" && \
      cd "$tmpdir"; \
      if [ $VERSION = "9.2.0" ]; then \
        ENABLE_FORTRAN=",fortran"; \
      else \
        ENABLE_FORTRAN=""; \
      fi; \
      /tmp/gcc-$VERSION/configure \
        --disable-multilib \
        --enable-languages=c,c++$ENABLE_FORTRAN \
        --prefix=/usr/local/gcc-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install-strip && \
      rm -rf /tmp/*; \
    done

# Check for latest version here: https://www.ruby-lang.org/en/downloads
ENV RUBY_VERSIONS="2.7.0"
RUN set -xe && \
    for VERSION in $RUBY_VERSIONS; do \
      curl -fSsL "https://cache.ruby-lang.org/pub/ruby/${VERSION%.*}/ruby-$VERSION.tar.gz" -o /tmp/ruby-$VERSION.tar.gz && \
      mkdir /tmp/ruby-$VERSION && \
      tar -xf /tmp/ruby-$VERSION.tar.gz -C /tmp/ruby-$VERSION --strip-components=1 && \
      rm /tmp/ruby-$VERSION.tar.gz && \
      cd /tmp/ruby-$VERSION && \
      ./configure \
        --disable-install-doc \
        --prefix=/usr/local/ruby-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# Check for latest version here: https://www.python.org/downloads
ENV PYTHON_VERSIONS="3.8.1 2.7.17"
RUN set -xe && \
    for VERSION in $PYTHON_VERSIONS; do \
      curl -fSsL "https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz" -o /tmp/python-$VERSION.tar.xz && \
      mkdir /tmp/python-$VERSION && \
      tar -xf /tmp/python-$VERSION.tar.xz -C /tmp/python-$VERSION --strip-components=1 && \
      rm /tmp/python-$VERSION.tar.xz && \
      cd /tmp/python-$VERSION && \
      ./configure \
        --prefix=/usr/local/python-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://ftp.gnu.org/gnu/octave
ENV OCTAVE_VERSIONS="5.1.0"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends gfortran libblas-dev liblapack-dev libpcre3-dev && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $OCTAVE_VERSIONS; do \
      curl -fSsL "https://ftp.gnu.org/gnu/octave/octave-$VERSION.tar.gz" -o /tmp/octave-$VERSION.tar.gz && \
      mkdir /tmp/octave-$VERSION && \
      tar -xf /tmp/octave-$VERSION.tar.gz -C /tmp/octave-$VERSION --strip-components=1 && \
      rm /tmp/octave-$VERSION.tar.gz && \
      cd /tmp/octave-$VERSION && \
      ./configure \
        --prefix=/usr/local/octave-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# Check for latest version here: https://jdk.java.net
ENV JAVA_VERSIONS="15"
RUN set -xe && \
  for VERSION in $JAVA_VERSIONS; do \
    echo "Installing OpenJDK $VERSION" && \
    # https://download.java.net/java/GA/jdk15/779bf45e88a44cbd9ea6621d33e33db1/36/GPL/openjdk-15_linux-aarch64_bin.tar.gz
    curl -fSsL "https://download.java.net/java/GA/jdk$VERSION/779bf45e88a44cbd9ea6621d33e33db1/36/GPL/openjdk-${VERSION}_linux-aarch64_bin.tar.gz" -o /tmp/jdk$VERSION.tar.gz && \
    mkdir /usr/local/jdk$VERSION && \
    tar -xf /tmp/jdk$VERSION.tar.gz -C /usr/local/jdk$VERSION --strip-components=1 && \
    rm /tmp/jdk$VERSION.tar.gz && \
    ln -s /usr/local/jdk$VERSION/bin/javac /usr/local/bin/javac && \
    ln -s /usr/local/jdk$VERSION/bin/java /usr/local/bin/java && \
    ln -s /usr/local/jdk$VERSION/bin/jar /usr/local/bin/jar; \
  done


# # Check for latest version here: https://ftpmirror.gnu.org/bash
ENV BASH_VERSIONS="5.0"
RUN set -xe && \
    for VERSION in $BASH_VERSIONS; do \
      curl -fSsL "https://ftpmirror.gnu.org/bash/bash-$VERSION.tar.gz" -o /tmp/bash-$VERSION.tar.gz && \
      mkdir /tmp/bash-$VERSION && \
      tar -xf /tmp/bash-$VERSION.tar.gz -C /tmp/bash-$VERSION --strip-components=1 && \
      rm /tmp/bash-$VERSION.tar.gz && \
      cd /tmp/bash-$VERSION && \
      ./configure \
        --prefix=/usr/local/bash-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://www.freepascal.org/download.html
ENV FPC_VERSIONS="3.2.2"
RUN set -xe && \
    for VERSION in $FPC_VERSIONS; do \
      curl -fSsL "https://sourceforge.net/projects/freepascal/files/Linux/$VERSION/fpc-$VERSION.aarch64-linux.tar/download" -o /tmp/fpc-$VERSION.tar && \
      mkdir /tmp/fpc-$VERSION && \
      tar -xf /tmp/fpc-$VERSION.tar -C /tmp/fpc-$VERSION --strip-components=1 && \
      rm /tmp/fpc-$VERSION.tar && \
      cd /tmp/fpc-$VERSION && \
      echo "/usr/local/fpc-$VERSION" | bash install.sh && \
      rm -rf /tmp/*; \
    done

# Check for latest version here: https://www.haskell.org/ghc/download.html
ENV HASKELL_VERSIONS="8.8.1"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      libgmp-dev \
      libtinfo5 \
      libncurses5 \
      libffi-dev \
      libnuma-dev \
      llvm-11 && \
    ln -sf /usr/lib/llvm-11/bin/opt /usr/local/bin/opt && \
    ln -sf /usr/lib/llvm-11/bin/llc /usr/local/bin/llc && \
    ln -sf /usr/lib/llvm-11/bin/llvm-config /usr/local/bin/llvm-config && \
    rm -rf /var/lib/apt/lists/* && \
    ARCH="$(dpkg --print-architecture)" && \
    case "$ARCH" in \
      amd64) GHC_ARCH="x86_64"; GHC_VARIANTS="deb9 deb8 ubuntu18.04";; \
      arm64) GHC_ARCH="aarch64"; GHC_VARIANTS="deb9 deb8 ubuntu18.04";; \
      *) echo "Unsupported architecture: $ARCH" >&2; exit 1;; \
    esac && \
    for VERSION in $HASKELL_VERSIONS; do \
      SUCCESS=0; \
      for DISTRO in $GHC_VARIANTS; do \
        URL="https://downloads.haskell.org/~ghc/$VERSION/ghc-$VERSION-${GHC_ARCH}-${DISTRO}-linux.tar.xz"; \
        if curl -fSsL "$URL" -o /tmp/ghc-$VERSION.tar.xz; then \
          SUCCESS=1; \
          break; \
        fi; \
      done; \
      if [ "$SUCCESS" -ne 1 ]; then \
        echo "No suitable binary distribution found for GHC $VERSION on $ARCH" >&2; \
        exit 1; \
      fi; \
      mkdir /tmp/ghc-$VERSION && \
      tar -xf /tmp/ghc-$VERSION.tar.xz -C /tmp/ghc-$VERSION --strip-components=1 && \
      rm /tmp/ghc-$VERSION.tar.xz && \
      cd /tmp/ghc-$VERSION && \
      ./configure \
        --prefix=/usr/local/ghc-$VERSION && \
      mkdir -p /usr/local/ghc-$VERSION/lib/ghc-$VERSION/latex && \
      PATH="/usr/lib/llvm-11/bin:$PATH" make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done


# # Check for latest version here: https://www.mono-project.com/download/stable
ENV MONO_VERSIONS="6.6.0.161"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends cmake python3 && \
    ln -sf python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $MONO_VERSIONS; do \
      curl -fSsL "https://download.mono-project.com/sources/mono/mono-$VERSION.tar.xz" -o /tmp/mono-$VERSION.tar.xz && \
      mkdir /tmp/mono-$VERSION && \
      tar -xf /tmp/mono-$VERSION.tar.xz -C /tmp/mono-$VERSION --strip-components=1 && \
      rm /tmp/mono-$VERSION.tar.xz && \
      cd /tmp/mono-$VERSION && \
      ./configure \
        --prefix=/usr/local/mono-$VERSION && \
      make -j$(nproc) && \
      make -j$(proc) install && \
      rm -rf /tmp/*; \
    done

  # Check for latest version here: https://nodejs.org/en
ENV NODE_VERSIONS="12.14.0"
RUN set -xe && \
    for VERSION in $NODE_VERSIONS; do \
      curl -fSsL "https://nodejs.org/dist/v$VERSION/node-v$VERSION.tar.gz" -o /tmp/node-$VERSION.tar.gz && \
      mkdir /tmp/node-$VERSION && \
      tar -xf /tmp/node-$VERSION.tar.gz -C /tmp/node-$VERSION --strip-components=1 && \
      rm /tmp/node-$VERSION.tar.gz && \
      cd /tmp/node-$VERSION && \
      export PYTHON=/usr/local/python-2.7.17/bin/python2.7 && \
      export PATH="/usr/local/python-2.7.17/bin:$PATH" && \
      ./configure \
        --prefix=/usr/local/node-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://github.com/erlang/otp/releases
ENV ERLANG_VERSIONS="22.2"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $ERLANG_VERSIONS; do \
      curl -fSsL "https://github.com/erlang/otp/archive/OTP-$VERSION.tar.gz" -o /tmp/erlang-$VERSION.tar.gz && \
      mkdir /tmp/erlang-$VERSION && \
      tar -xf /tmp/erlang-$VERSION.tar.gz -C /tmp/erlang-$VERSION --strip-components=1 && \
      rm /tmp/erlang-$VERSION.tar.gz && \
      cd /tmp/erlang-$VERSION && \
      export CC="gcc -fcommon" && \
      export CFLAGS="${CFLAGS:--O2 -g} -fcommon" && \
      ./otp_build autoconf && \
      ./configure \
        --prefix=/usr/local/erlang-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done; \
    ln -s /usr/local/erlang-22.2/bin/erl /usr/local/bin/erl

# # Check for latest version here: https://github.com/elixir-lang/elixir/releases
ENV ELIXIR_VERSIONS="1.9.4"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $ELIXIR_VERSIONS; do \
      curl -fSsL "https://github.com/elixir-lang/elixir/releases/download/v$VERSION/Precompiled.zip" -o /tmp/elixir-$VERSION.zip && \
      unzip -d /usr/local/elixir-$VERSION /tmp/elixir-$VERSION.zip && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://www.rust-lang.org
ENV RUST_VERSIONS="1.40.0"
RUN set -xe && \
    for VERSION in $RUST_VERSIONS; do \
      curl -fSsL "https://static.rust-lang.org/dist/rust-$VERSION-aarch64-unknown-linux-gnu.tar.xz" -o /tmp/rust-$VERSION.tar.gz && \
      mkdir /tmp/rust-$VERSION && \
      tar -xf /tmp/rust-$VERSION.tar.gz -C /tmp/rust-$VERSION --strip-components=1 && \
      rm /tmp/rust-$VERSION.tar.gz && \
      cd /tmp/rust-$VERSION && \
      ./install.sh \
        --prefix=/usr/local/rust-$VERSION \
        --components=rustc,rust-std-aarch64-unknown-linux-gnu && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://golang.org/dl
ENV GO_VERSIONS="1.13.5"
RUN set -xe && \
    for VERSION in $GO_VERSIONS; do \
      curl -fSsL "https://go.dev/dl/go$VERSION.linux-arm64.tar.gz" -o /tmp/go-$VERSION.tar.gz && \
      mkdir /usr/local/go-$VERSION && \
      tar -xf /tmp/go-$VERSION.tar.gz -C /usr/local/go-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://sourceforge.net/projects/fbc/files/Binaries%20-%20Linux
ENV FBC_VERSIONS="1.07.3 1.07.2 1.07.1 1.06.0"
RUN set -xe && \
    ARCH="$(dpkg --print-architecture)" && \
    GLIBC_VERSION="$(ldd --version | head -n1 | awk '{print $NF}')" && \
    case "$ARCH" in \
      amd64) FBC_VARIANTS="linux-x86_64 linux-x86";; \
      arm64) FBC_VARIANTS="linux-arm64 linux-arm";; \
      armhf) FBC_VARIANTS="linux-arm";; \
      i386) FBC_VARIANTS="linux-x86";; \
      *) echo "Skipping FreeBASIC: unsupported architecture $ARCH" && exit 0;; \
    esac && \
    INSTALLED=0 && \
    for VERSION in $FBC_VERSIONS; do \
      rm -f /tmp/fbc-${VERSION}.tar.gz; \
      SUCCESS=0; \
      for VARIANT in $FBC_VARIANTS; do \
        URL="https://sourceforge.net/projects/fbc/files/FreeBASIC-$VERSION/Binaries-Linux/FreeBASIC-$VERSION-${VARIANT}.tar.gz/download"; \
        if curl -fSsL "$URL" -o /tmp/fbc-${VERSION}.tar.gz; then \
          SUCCESS=1; \
          break; \
        fi; \
      done; \
      if [ "$SUCCESS" -ne 1 ]; then \
        echo "No suitable FreeBASIC binary archive found for $VERSION on $ARCH, trying next version" >&2; \
        continue; \
      fi; \
      mkdir -p /usr/local/fbc-$VERSION; \
      tar -xf /tmp/fbc-${VERSION}.tar.gz -C /usr/local/fbc-$VERSION --strip-components=1; \
      REQUIRED_GLIBC="$(strings /usr/local/fbc-$VERSION/bin/fbc 2>/dev/null | grep -oE 'GLIBC_[0-9]+\\.[0-9]+' | sort -uV | tail -n1 | cut -d_ -f2)" || REQUIRED_GLIBC=""; \
      if [ -z "$REQUIRED_GLIBC" ]; then \
        REQUIRED_GLIBC="0"; \
      fi; \
      if dpkg --compare-versions "$GLIBC_VERSION" ge "$REQUIRED_GLIBC"; then \
        INSTALLED=1; \
        rm -rf /tmp/*; \
        break; \
      else \
        echo "FreeBASIC $VERSION requires glibc $REQUIRED_GLIBC, but system has $GLIBC_VERSION; removing and trying older version." >&2; \
        rm -rf /usr/local/fbc-$VERSION; \
        rm -f /tmp/fbc-${VERSION}.tar.gz; \
        rm -rf /tmp/*; \
      fi; \
    done && \
    if [ "$INSTALLED" -ne 1 ]; then \
      echo "Unable to install FreeBASIC compatible with glibc $GLIBC_VERSION on $ARCH" >&2; \
      exit 1; \
    fi

# # Check for latest version here: https://github.com/ocaml/ocaml/releases
ENV OCAML_VERSIONS="4.09.0"
RUN set -xe && \
    for VERSION in $OCAML_VERSIONS; do \
      curl -fSsL "https://github.com/ocaml/ocaml/archive/$VERSION.tar.gz" -o /tmp/ocaml-$VERSION.tar.gz && \
      mkdir /tmp/ocaml-$VERSION && \
      tar -xf /tmp/ocaml-$VERSION.tar.gz -C /tmp/ocaml-$VERSION --strip-components=1 && \
      rm /tmp/ocaml-$VERSION.tar.gz && \
      cd /tmp/ocaml-$VERSION && \
      export CC="gcc -fcommon" && \
      export CFLAGS="$CFLAGS -fcommon" && \
      ./configure \
        -prefix /usr/local/ocaml-$VERSION \
        --disable-ocamldoc --disable-debugger && \
      make -j$(nproc) world.opt && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://www.php.net/downloads
ENV PHP_VERSIONS="7.4.1"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends bison re2c && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $PHP_VERSIONS; do \
      curl -fSsL "https://codeload.github.com/php/php-src/tar.gz/php-$VERSION" -o /tmp/php-$VERSION.tar.gz && \
      mkdir /tmp/php-$VERSION && \
      tar -xf /tmp/php-$VERSION.tar.gz -C /tmp/php-$VERSION --strip-components=1 && \
      rm /tmp/php-$VERSION.tar.gz && \
      cd /tmp/php-$VERSION && \
      ./buildconf --force && \
      ./configure \
        --prefix=/usr/local/php-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://dlang.org/download.html#dmd
ENV D_VERSIONS="2.089.1"
RUN set -xe && \
    ARCH="$(dpkg --print-architecture)" && \
    if [ "$ARCH" = "amd64" ] || [ "$ARCH" = "i386" ]; then \
      for VERSION in $D_VERSIONS; do \
        curl -fSsL "http://downloads.dlang.org/releases/2.x/$VERSION/dmd.$VERSION.linux.tar.xz" -o /tmp/d-$VERSION.tar.gz && \
        mkdir /usr/local/d-$VERSION && \
        tar -xf /tmp/d-$VERSION.tar.gz -C /usr/local/d-$VERSION --strip-components=1 && \
        rm -rf /usr/local/d-$VERSION/linux/*32 && \
        rm -rf /tmp/*; \
      done; \
    else \
      echo "Skipping DMD install: binaries only available for x86/x86_64 (detected $ARCH)"; \
    fi

# # Check for latest version here: https://www.lua.org/download.html
ENV LUA_VERSIONS="5.3.5"
RUN set -xe && \
    for VERSION in $LUA_VERSIONS; do \
      curl -fSsL "https://www.lua.org/ftp/lua-$VERSION.tar.gz" -o /tmp/lua-$VERSION.tar.gz && \
      mkdir /tmp/lua-$VERSION && \
      tar -xf /tmp/lua-$VERSION.tar.gz -C /tmp/lua-$VERSION --strip-components=1 && \
      rm /tmp/lua-$VERSION.tar.gz && \
      cd /tmp/lua-$VERSION && \
      make linux && \
      make INSTALL_TOP=/usr/local/lua-$VERSION install && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://github.com/microsoft/TypeScript/releases
ENV TYPESCRIPT_VERSIONS="3.7.4"
RUN set -xe && \
    curl -fSsL "https://deb.nodesource.com/setup_12.x" | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $TYPESCRIPT_VERSIONS; do \
      npm install -g typescript@$VERSION; \
    done

# # Check for latest version here: https://nasm.us
ENV NASM_VERSIONS="2.14.02"
RUN set -xe apt-get install qemu-user 
RUN set -xe && \
    for VERSION in $NASM_VERSIONS; do \
      curl -fSsL "https://www.nasm.us/pub/nasm/releasebuilds/$VERSION/nasm-$VERSION.tar.gz" -o /tmp/nasm-$VERSION.tar.gz && \
      mkdir /tmp/nasm-$VERSION && \
      tar -xf /tmp/nasm-$VERSION.tar.gz -C /tmp/nasm-$VERSION --strip-components=1 && \
      rm /tmp/nasm-$VERSION.tar.gz && \
      cd /tmp/nasm-$VERSION && \
      ./configure \
        --prefix=/usr/local/nasm-$VERSION && \
      make -j$(nproc) nasm ndisasm && \
      make -j$(nproc) strip && \
      make -j$(nproc) install && \
      echo "/usr/local/nasm-$VERSION/bin/nasm -o main.o \$@ && ld main.o" >> /usr/local/nasm-$VERSION/bin/nasmld && \
      chmod +x /usr/local/nasm-$VERSION/bin/nasmld && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: http://gprolog.org/#download
ENV GPROLOG_VERSIONS="1.4.5"
RUN set -xe && \
    ARCH="$(dpkg --print-architecture)" && \
    case "$ARCH" in \
      amd64|i386) \
        for VERSION in $GPROLOG_VERSIONS; do \
          curl -fSsL "https://ftp.gnu.org/gnu/gprolog/gprolog-$VERSION.tar.gz" -o /tmp/gprolog-$VERSION.tar.gz && \
          mkdir /tmp/gprolog-$VERSION && \
          tar -xf /tmp/gprolog-$VERSION.tar.gz -C /tmp/gprolog-$VERSION --strip-components=1 && \
          rm /tmp/gprolog-$VERSION.tar.gz && \
          cd /tmp/gprolog-$VERSION/src && \
          ./configure \
            --prefix=/usr/local/gprolog-$VERSION && \
          make -j$(nproc) && \
          make -j$(nproc) install-strip && \
          rm -rf /tmp/*; \
        done ;; \
      *) \
        echo "Skipping GProlog build: unsupported architecture $ARCH"; \
    esac

# # Check for latest version here: http://www.sbcl.org/platform-table.html
ENV SBCL_VERSIONS="1.4.2"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends bison re2c && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $SBCL_VERSIONS; do \
      curl -fSsL "http://prdownloads.sourceforge.net/sbcl/sbcl-$VERSION-arm64-linux-binary.tar.bz2" -o /tmp/sbcl-$VERSION.tar.bz2 && \
      mkdir /tmp/sbcl-$VERSION && \
      tar -xf /tmp/sbcl-$VERSION.tar.bz2 -C /tmp/sbcl-$VERSION --strip-components=1 && \
      cd /tmp/sbcl-$VERSION && \
      export INSTALL_ROOT=/usr/local/sbcl-$VERSION && \
      sh install.sh && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://ftp.gnu.org/gnu/gnucobol
ENV COBOL_VERSIONS="2.2"
RUN set -xe && \
    for VERSION in $COBOL_VERSIONS; do \
      curl -fSsL "https://ftp.gnu.org/gnu/gnucobol/gnucobol-$VERSION.tar.xz" -o /tmp/gnucobol-$VERSION.tar.xz && \
      mkdir /tmp/gnucobol-$VERSION && \
      tar -xf /tmp/gnucobol-$VERSION.tar.xz -C /tmp/gnucobol-$VERSION --strip-components=1 && \
      rm /tmp/gnucobol-$VERSION.tar.xz && \
      cd /tmp/gnucobol-$VERSION && \
      ./configure \
        --prefix=/usr/local/gnucobol-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://swift.org/download
ENV SWIFT_VERSIONS="6.2.1"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends libncurses5 && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $SWIFT_VERSIONS; do \
      curl -fSsL "https://download.swift.org/swift-$VERSION-release/static-sdk/swift-$VERSION-RELEASE/swift-$VERSION-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz" -o /tmp/swift-$VERSION.tar.gz && \
      mkdir /usr/local/swift-$VERSION && \
      tar -xf /tmp/swift-$VERSION.tar.gz -C /usr/local/swift-$VERSION --strip-components=2 && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://kotlinlang.org
ENV KOTLIN_VERSIONS="1.3.70"
RUN set -xe && \
    for VERSION in $KOTLIN_VERSIONS; do \
      curl -fSsL "https://github.com/JetBrains/kotlin/releases/download/v$VERSION/kotlin-compiler-$VERSION.zip" -o /tmp/kotlin-$VERSION.zip && \
      unzip -d /usr/local/kotlin-$VERSION /tmp/kotlin-$VERSION.zip && \
      mv /usr/local/kotlin-$VERSION/kotlinc/* /usr/local/kotlin-$VERSION/ && \
      rm -rf /usr/local/kotlin-$VERSION/kotlinc && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://hub.docker.com/_/mono
# # I currently use this to add support for Visual Basic.Net but this can be also
# # used to support C# language which has been already supported but with manual
# # installation of Mono (see above).
ENV MONO_VERSION="6.6.0.161"
RUN set -xe && \
    ARCH="$(dpkg --print-architecture)" && \
    if [ "$ARCH" = "amd64" ] || [ "$ARCH" = "i386" ]; then \
      apt-get update && \
      apt-get install -y --no-install-recommends gnupg dirmngr && \
      rm -rf /var/lib/apt/lists/* && \
      export GNUPGHOME="$(mktemp -d)" && \
      gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
      gpg --batch --export --armor 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF > /etc/apt/trusted.gpg.d/mono.gpg.asc && \
      gpgconf --kill all && \
      rm -rf "$GNUPGHOME" && \
      apt-key list | grep Xamarin && \
      apt-get purge -y --auto-remove gnupg dirmngr && \
      echo "deb http://download.mono-project.com/repo/debian stable-stretch/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-official-stable.list && \
      apt-get update && \
      apt-get install -y --no-install-recommends mono-vbnc && \
      rm -rf /var/lib/apt/lists/* /tmp/*; \
    else \
      echo "Skipping mono-vbnc: unsupported architecture $ARCH"; \
    fi

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
ARG DEBIAN_FRONTEND=noninteractive 
ENV TZ=Etc/UTC 


# # Check for latest version here: https://packages.debian.org/search?keywords=clang
# # Used for additional compilers for C, C++ and used for Objective-C.
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends clang gnustep-devel && \
    rm -rf /var/lib/apt/lists/*

# # Check for latest version here: https://cloud.r-project.org/src/base
ENV R_VERSIONS="4.0.0"
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends libpcre2-dev && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $R_VERSIONS; do \
      curl -fSsL "https://cloud.r-project.org/src/base/R-4/R-$VERSION.tar.gz" -o /tmp/r-$VERSION.tar.gz && \
      mkdir /tmp/r-$VERSION && \
      tar -xf /tmp/r-$VERSION.tar.gz -C /tmp/r-$VERSION --strip-components=1 && \
      rm /tmp/r-$VERSION.tar.gz && \
      cd /tmp/r-$VERSION && \
      ./configure \
        --prefix=/usr/local/r-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# # Check for latest version here: https://packages.debian.org/buster/sqlite3
# # Used for support of SQLite.
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends sqlite3 && \
    rm -rf /var/lib/apt/lists/*

# # Check for latest version here: https://scala-lang.org
ENV SCALA_VERSIONS="2.13.2"
RUN set -xe && \
    for VERSION in $SCALA_VERSIONS; do \
      curl -fSsL "https://downloads.lightbend.com/scala/$VERSION/scala-$VERSION.tgz" -o /tmp/scala-$VERSION.tgz && \
      mkdir /usr/local/scala-$VERSION && \
      tar -xf /tmp/scala-$VERSION.tgz -C /usr/local/scala-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

# # Support for Perl came "for free" since it is already installed.

# # Check for latest version here: https://github.com/clojure/clojure/releases
ENV CLOJURE_VERSION="1.10.1"
RUN set -xe && \
    mkdir -p /usr/local/clojure-$CLOJURE_VERSION && \
    curl -fSsL "https://repo1.maven.org/maven2/org/clojure/clojure/$CLOJURE_VERSION/clojure-$CLOJURE_VERSION.jar" \
      -o /usr/local/clojure-$CLOJURE_VERSION/clojure.jar && \
    rm -rf /tmp/*

# # Check for latest version here: https://github.com/dotnet/sdk/releases
RUN set -xe && \
    curl -fSsL "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.415/dotnet-sdk-8.0.415-linux-arm64.tar.gz" -o /tmp/dotnet.tar.gz && \
    mkdir /usr/local/dotnet-sdk && \
    tar -xf /tmp/dotnet.tar.gz -C /usr/local/dotnet-sdk && \
    rm -rf /tmp/*

# # Check for latest version here: https://groovy.apache.org/download.html
RUN set -xe && \
    for URL in \
      "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-3.0.3.zip" \
      "https://archive.apache.org/dist/groovy/3.0.3/distribution/apache-groovy-binary-3.0.3.zip" \
    ; do \
      if curl -fSsL "$URL" -o /tmp/groovy.zip; then \
        break; \
      fi; \
      rm -f /tmp/groovy.zip; \
    done && \
    [ -f /tmp/groovy.zip ] && \
    unzip /tmp/groovy.zip -d /usr/local && \
    rm -rf /tmp/*

RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/judge0/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout ad39cc4d0fbb577fb545910095c9da5ef8fc9a1a && \
    make -j$(nproc) install && \
    rm -rf /tmp/*

ENV BOX_ROOT="/var/local/lib/isolate"

LABEL maintainer="Aditya Singh <contact@mechaadi.com>"
LABEL version="1.0.0"
