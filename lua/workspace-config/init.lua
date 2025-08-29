
local M = {}

local function load_lsp_servers(servers)
  vim.notify('Loading workspace LSPs')
  
  local mason_ok, mason = pcall(require, 'mason')
  if not mason_ok then
    vim.notify('Mason not found - please install mason.nvim', vim.log.levels.WARN)
    return false
  end

  local registry_ok, mason_registry = pcall(require, 'mason-registry')
  if not registry_ok then
    vim.notify('Mason registry not found', vim.log.levels.WARN)
    return false
  end

  for _, server in ipairs(servers) do
    if not mason_registry.is_installed(server) then
      vim.notify('Installing ' .. server .. '...', vim.log.levels.INFO)
      vim.cmd('MasonInstall ' .. server)
    end
  end
  
  return true
end

local function configure_lsp(lsp_configs)
  vim.notify('Configuring workspace LSPs')
  
  local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
  if not lspconfig_ok then
    vim.notify('lspconfig not found - please install nvim-lspconfig', vim.log.levels.WARN)
    return false
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  
  local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if cmp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  for server_name, config in pairs(lsp_configs) do
    local server_config = vim.tbl_deep_extend('force', {
      capabilities = capabilities,
    }, config)
    
    if config.root_dir_patterns then
      server_config.root_dir = lspconfig.util.root_pattern(unpack(config.root_dir_patterns))
      server_config.root_dir_patterns = nil
    end
    
    lspconfig[server_name].setup(server_config)
  end
  
  return true
end

local function load_project_config()
  local project_config = vim.fn.getcwd() .. "/.nvimrc.lua"
  
  if vim.fn.filereadable(project_config) == 0 then
    return nil
  end

  local chunk, err = loadfile(project_config)
  if not chunk then
    vim.notify('Error loading .nvimrc.lua: ' .. (err or 'unknown'), vim.log.levels.ERROR)
    return nil
  end

  local ok, config_result = pcall(chunk)
  if not ok then
    vim.notify('Error executing .nvimrc.lua: ' .. (config_result or 'unknown'), vim.log.levels.ERROR)
    return nil
  end

  if config_result then
    vim.notify('Config result keys: ' .. vim.inspect(vim.tbl_keys(config_result)))
  end

  return config_result
end

function M.setup(opts)
  opts = opts or {}
  vim.notify("Loading Workspace")  
  local config = load_project_config()
  if not config then
    return
  end

  if config.lsp_servers and next(config.lsp_servers) then
    load_lsp_servers(config.lsp_servers)
  end

  if config.lsp_configs and next(config.lsp_configs) then
    configure_lsp(config.lsp_configs)
  end
end

-- Auto-load on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    M.setup()
  end,
  desc = "Load workspace configuration"
})

-- Command to manually reload
vim.api.nvim_create_user_command("WorkspaceConfigReload", function()
  M.setup()
end, { desc = "Reload workspace configuration" })

return M
