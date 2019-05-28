CC := clang
CFLAGS := --target=wasm32 -Os
compiler_rt := $(filter-out $(PWD)/../compiler-rt/build/lib/builtins/CMakeFiles/clang_rt.builtins-wasm32.dir/gcc_personality_v0.c.obj, $(wildcard $(PWD)/../compiler-rt/build/lib/builtins/CMakeFiles/clang_rt.builtins-wasm32.dir/*.obj))
LDFLAGS :=-Wl,--no-entry -Wl,--allow-undefined-file=$(PWD)/../wasm-loader-browsix/functions -Wl,--import-memory -Wl,--shared-memory -Wl,--max-memory=67108864 -Wl,-error-limit=0 $(compiler_rt)
ARCH := wasm32
