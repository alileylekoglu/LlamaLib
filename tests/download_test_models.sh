#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Download with failure detection, retries, a fallback URL and a GGUF
# magic-bytes check (a failed CDN response used to be saved as model.gguf,
# crashing the tests with 'invalid magic characters').
download_gguf() {
    local out="$1"; shift
    if [ -f "$out" ] && [ "$(head -c 4 "$out")" == "GGUF" ]; then
        return 0
    fi
    for url in "$@"; do
        echo "downloading $out from $url"
        if curl -fL --retry 3 --retry-delay 5 -o "$out" "$url" \
           && [ "$(head -c 4 "$out")" == "GGUF" ]; then
            return 0
        fi
        rm -f "$out"
    done
    echo "ERROR: could not download a valid GGUF for $out" >&2
    return 1
}

download_gguf "$SCRIPT_DIR/model.gguf" \
    "https://huggingface.co/unsloth/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q4_K_M.gguf" \
    "https://huggingface.co/Qwen/Qwen3-0.6B-GGUF/resolve/main/Qwen3-0.6B-Q8_0.gguf"

download_gguf "$SCRIPT_DIR/model_embedding.gguf" \
    "https://huggingface.co/CompendiumLabs/bge-small-en-v1.5-gguf/resolve/main/bge-small-en-v1.5-q4_k_m.gguf" \
    "https://huggingface.co/second-state/bge-small-en-v1.5-GGUF/resolve/main/bge-small-en-v1.5-Q4_K_M.gguf"
