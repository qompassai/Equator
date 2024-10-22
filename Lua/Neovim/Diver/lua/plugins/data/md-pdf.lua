return {
    'arminveres/md-pdf.nvim',
    lazy = true,
    branch = 'main',
    keys = {
        {
            "<leader>,",
            function() require("md-pdf").convert_md_to_pdf() end,
            desc = "Convert Markdown to PDF",
        },
    },
    opts = {
        pdf_engine = "pandoc",
        pdf_engine_opts = "--pdf-engine=xelatex",
        extra_opts = "--variable=mainfont:Arial --variable=fontsize:12pt",
        output_path = "./",
        auto_open = true,
        pandoc_path = "/usr/bin/pandoc",
        theme = "default",
        margins = "1in",
        toc = false,
        highlight = "tango",
    },
    config = function(_, opts)
        require("md-pdf").setup(opts)
    end,
}

