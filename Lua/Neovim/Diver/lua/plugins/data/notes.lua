-- plugins for notetaking and knowledge management

return {
  {
    'nvim-neorg/neorg',
    lazy = true,
    enabled = true,
    config = function()
      require('neorg').setup {
        load = {
          ["core.defaults"] = {},  -- Load all the default modules
          ["core.norg.concealer"] = {},  -- Pretty icons for your notes
          ["core.norg.dirman"] = {  -- Manage directories of notes
            config = {
              workspaces = {
                notes = "~/neorg/notes",
                work = "~/neorg/work",
                personal = "~/neorg/personal",
              },
            },
          },
          ["core.norg.completion"] = {
            config = {
              engine = "nvim-cmp",  -- Use nvim-cmp for autocompletion
            },
          },
          ["core.integrations.telescope"] = {},  -- Integrate Neorg with Telescope for better search/navigation
          ["core.norg.journal"] = {  -- Add journal functionality
            config = {
              workspace = "personal",
            },
          },
          ["core.gtd.base"] = {  -- Add GTD (Getting Things Done) module
            config = {
              workspace = "work",
            },
          },
        },
      }
    end,
  },
}
