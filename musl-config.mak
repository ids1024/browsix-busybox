CC := clang
CFLAGS := --target=wasm32 -Os
LDFLAGS :=-Wl,--no-entry -Wl,--allow-undefined-file=$(PWD)/../wasm-loader-browsix/functions -Wl,--import-memory -Wl,--shared-memory -Wl,--max-memory=67108864 -Wl,-error-limit=0 -Wl,-whole-archive -L$(PWD)/../compiler-rt/build/lib/generic -lclang_rt.builtins-wasm32
ARCH := wasm32
