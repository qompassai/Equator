local M = {}

M.opts = {
    on_attach = function(bufnr)
        local gitsigns = package.loaded.gitsigns
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd('normal! ]c')
            else
                gitsigns.next_hunk()
            end
        end, { desc = "Next Hunk" })

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd('normal! [c')
            else
                gitsigns.prev_hunk()
            end
        end, { desc = "Previous Hunk" })

        -- Actions
        local stage_or_reset = function(action, range)
            return function()
                if range then
                    gitsigns[action] { vim.fn.line('.'), vim.fn.line('v') }
                else
                    gitsigns[action]()
                end
            end
        end

        map('n', '<leader>hs', stage_or_reset('stage_hunk'), { desc = "Stage Hunk" })
        map('n', '<leader>hr', stage_or_reset('reset_hunk'), { desc = "Reset Hunk" })
        map('v', '<leader>hs', stage_or_reset('stage_hunk', true), { desc = "Stage Hunk (Visual)" })
        map('v', '<leader>hr', stage_or_reset('reset_hunk', true), { desc = "Reset Hunk (Visual)" })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = "Stage Buffer" })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = "Reset Buffer" })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = "Preview Hunk" })
        map('n', '<leader>hb', function()
            gitsigns.blame_line { full = true }
        end, { desc = "Blame Line" })
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = "Toggle Blame Line" })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = "Diff This" })
        map('n', '<leader>hD', function()
            gitsigns.diffthis('~')
        end, { desc = "Diff This ~" })
        map('n', '<leader>td', gitsigns.toggle_deleted, { desc = "Toggle Deleted" })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select Hunk" })
    end
}

return M
