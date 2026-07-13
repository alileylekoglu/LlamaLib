// Stub of the generated webui asset header (tools/ui/embed.cpp, n_assets = 0).
// LlamaLib embeds the server as a library; the browser UI is never served,
// so we provide the empty-asset variant instead of running the embed step
// (which requires downloading prebuilt UI assets / a host compiler).
#pragma once

#include <array>
#include <string>

struct llama_ui_asset {
    std::string           name;
    const unsigned char * data;
    std::size_t           size;
    std::string           etag;
    std::string           type;
};

const llama_ui_asset * llama_ui_find_asset(const std::string & name);
bool llama_ui_use_gzip();
const std::array<llama_ui_asset, 0> & llama_ui_get_assets();
