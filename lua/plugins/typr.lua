return {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {
        custom_text_path = vim.fn.stdpath("config") .. "/assets/anthem.txt",
    },
    cmd = { "Typr", "TyprStats" },
}
