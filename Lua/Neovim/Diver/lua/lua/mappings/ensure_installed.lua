local registry = require('mason-registry')

---@param source_name string
local function resolve_package(source_name)
    local Optional = require('mason-core.optional')

    -- Manually define the source mappings (tool -> package name)
    local source_mappings = {
        prettier = "prettier",
        eslint_d = "eslint_d",
        black = "black",
        stylua = "stylua",
        -- Add more tools here as needed
    }

    return Optional.of_nilable(source_mappings[source_name]):map(function(package_name)
        if not registry.has_package(package_name) then
            return nil
        end
        local ok, pkg = pcall(registry.get_package, package_name)
        if ok then
            return pkg
        end
    end)
end

local function ensure_installed()
    -- Manually define the settings with tools to be installed
    local settings = {
        current = {
            ensure_installed = {
                "prettier",
                "eslint_d",
                "black",
                "stylua"
                -- Add more tools as needed
            }
        }
    }

    for _, source_identifier in ipairs(settings.current.ensure_installed) do
        local Package = require('mason-core.package')

        local source_name, version = Package.Parse(source_identifier)
        resolve_package(source_name):if_present(
            function(pkg)
                if not pkg:is_installed() then
                    vim.notify(('[mason-none-ls] installing %s'):format(pkg.name))
                    pkg:install({
                        version = version,
                    }):once(
                        'closed',
                        vim.schedule_wrap(function()
                            if pkg:is_installed() then
                                vim.notify(('[mason-none-ls] %s was installed'):format(pkg.name))
                            else
                                vim.notify(
                                    ('[mason-none-ls] failed to install %s. Installation logs are available in :Mason and :MasonLog'):format(
                                        pkg.name
                                    ),
                                    vim.log.levels.ERROR
                                )
                            end
                        end)
                    )
                end
            end
        )
    end
end

if registry.refresh then
    return function()
        registry.refresh(vim.schedule_wrap(ensure_installed))
    end
else
    return ensure_installed
end

