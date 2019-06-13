FROM alpine:3.9.3 AS fastcomp

RUN apk add --no-cache build-base git cmake python

RUN git clone https://github.com/emscripten-core/emscripten-fastcomp -b 1.37.22 fastcomp
RUN git clone https://github.com/emscripten-core/emscripten-fastcomp-clang -b 1.37.22 fastcomp/tools/clang

COPY patches ./patches
RUN git -C fastcomp apply ../patches/dynamiclibrary-fix-build-musl.patch
RUN git -C fastcomp apply ../patches/llvm-fix-build-with-musl-libc.patch
RUN git -C fastcomp apply ../patches/char-sign.patch

RUN cd fastcomp \
    && mkdir build \
    && cd build \
    && CFLAGS=-Wno-error CXXFLAGS=-Wno-error cmake .. -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="host;JSBackend" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DCLANG_INCLUDE_TESTS=OFF \
    && make -j4

FROM alpine:3.9.3
RUN apk add --no-cache python nodejs npm alpine-sdk python3 clang
COPY --from=fastcomp /fastcomp/build/bin /fastcomp
RUN echo "{\"allow_root\": true}" > ~/.bowerrc
