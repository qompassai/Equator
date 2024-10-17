return
    {
    'arminveres/md-pdf.nvim',
        lazy = true,
    branch = 'main', -- you can assume that main is somewhat stable until releases will be made
    keys = {
        {
            "<leader>,",
            function() require("md-pdf").convert_md_to_pdf() end,
            desc = "Markdown preview",
        },
    },
    opts = {},
}
