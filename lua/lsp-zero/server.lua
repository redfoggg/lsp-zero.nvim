local M = {
  default_config = false,
  common_attach = nil,
  has_lspconfig = false,
  cmp_capabilities = false,
  setup_done = false
}

local s = {}

local state = {
  exclude = {},
  capabilities = nil,
  omit_keys = {n = {}, i = {}, x = {}},
}

function M.extend_lspconfig()
  if M.setup_done then
    return
  end

  local util = require('lspconfig.util')

  util.default_config.capabilities = s.set_capabilities()

  util.on_setup = util.add_hook_after(util.on_setup, function(config, user_config)
    -- looks like some lsp servers can override the capabilities option
    -- during "config definition". so, now we have to do this.
    s.ensure_capabilities(config, user_config)

    if type(M.default_config) == 'table' then
      s.apply_global_config(config, user_config, M.default_config)
    end
  end)

  M.has_lspconfig = true
  M.setup_done = true
end

function M.setup(name, opts)
  if type(name) ~= 'string' or state.exclude[name] then
    return false
  end

  if type(opts) ~= 'table' then
    opts = {}
  end

  M.skip_setup(name)

  local lsp = require('lspconfig')[name]

  if lsp.manager then
    return false
  end

  local ok = pcall(lsp.setup, opts)

  if not ok then
    local msg = '[lsp-zero] Failed to setup %s.\n'
      .. 'Configure this server using lspconfig to get the full error message.'

    vim.notify(msg:format(name), vim.log.levels.WARN)
    return false
  end

  return true
end

function M.default_keymaps(opts)
  local fmt = function(cmd) return function(str) return cmd:format(str) end end

  local buffer = opts.buffer or vim.api.nvim_get_current_buf()
  local keep_defaults = true
  local exclude = {}

  if type(opts.preserve_mappings) == 'boolean' then
    keep_defaults = opts.preserve_mappings
  end

  if type(opts.exclude) == 'table' then
    exclude = opts.exclude
  end

  local lsp = fmt('<cmd>lua vim.lsp.%s<cr>')
  local diagnostic = fmt('<cmd>lua vim.diagnostic.%s<cr>')

  local map = function(m, lhs, rhs)
    if vim.tbl_contains(exclude, lhs) then
      return
    end

    if keep_defaults and s.map_check(m, lhs) then
      return
    end

    local key_opts = {buffer = buffer}
    vim.keymap.set(m, lhs, rhs, key_opts)
  end

  map('n', 'K', lsp 'buf.hover()')
  map('n', 'gd', lsp 'buf.definition()')
  map('n', 'gD', lsp 'buf.declaration()')
  map('n', 'gi', lsp 'buf.implementation()')
  map('n', 'go', lsp 'buf.type_definition()')
  map('n', 'gr', lsp 'buf.references()')
  map('n', 'gs', lsp 'buf.signature_help()')
  map('n', '<F2>', lsp 'buf.rename()')
  map('n', '<F3>', lsp 'buf.format({async = true})')
  map('x', '<F3>', lsp 'buf.format({async = true})')
  map('n', '<F4>', lsp 'buf.code_action()')

  if vim.lsp.buf.range_code_action then
    map('x', '<F4>', lsp 'buf.range_code_action()')
  else
    map('x', '<F4>', lsp 'buf.code_action()')
  end

  map('n', 'gl', diagnostic 'open_float()')
  map('n', '[d', diagnostic 'goto_prev()')
  map('n', ']d', diagnostic 'goto_next()')
end

function M.set_sign_icons(opts)
  opts = opts or {}

  local sign = function(args)
    if opts[args.name] == nil then
      return
    end

    vim.fn.sign_define(args.hl, {
      texthl = args.hl,
      text = opts[args.name],
      numhl = ''
    })
  end

  sign({name = 'error', hl = 'DiagnosticSignError'})
  sign({name = 'warn', hl = 'DiagnosticSignWarn'})
  sign({name = 'hint', hl = 'DiagnosticSignHint'})
  sign({name = 'info', hl = 'DiagnosticSignInfo'})
end

function M.nvim_workspace(opts)
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  local config = {
    settings = {
      Lua = {
        -- Disable telemetry
        telemetry = {enable = false},
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'}
        },
        workspace = {
          checkThirdParty = false,
          library = {
            -- Make the server aware of Neovim runtime files
            vim.fn.expand('$VIMRUNTIME/lua'),
            vim.fn.stdpath('config') .. '/lua'
          }
        }
      }
    }
  }

  return vim.tbl_deep_extend('force', config, opts or {})
end

function M.client_capabilities()
  if state.capabilities == nil then
    if M.has_lspconfig == false then
      local ok = pcall(require, 'lspconfig')
      M.has_lspconfig = ok
    end
    return s.set_capabilities()
  end

  return state.capabilities
end

function M.set_buf_commands(bufnr)
  local bufcmd = vim.api.nvim_buf_create_user_command
  local format = function(input)
    if #input.fargs > 2 then
      vim.notify('Too many arguments for LspZeroFormat', vim.log.levels.ERROR)
      return
    end

    local server = input.fargs[1]
    local timeout = input.fargs[2]

    if timeout and timeout:find('timeout=') then
      timeout = timeout:gsub('timeout=', '')
      timeout = tonumber(timeout)
    end

    if server and server:find('timeout=') then
      timeout = server:gsub('timeout=', '')
      timeout = tonumber(timeout)
      server = input.fargs[2]
    end

    vim.lsp.buf.format({
      async = input.bang,
      timeout_ms = timeout,
      name = server,
    })
  end

  bufcmd(bufnr, 'LspZeroFormat', format, {range = true, bang = true, nargs = '*'})

  bufcmd(
    bufnr,
    'LspZeroWorkspaceRemove',
    'lua vim.lsp.buf.remove_workspace_folder()',
    {}
  )
end

function M.skip_setup(name)
  if type(name) == 'string' then
    state.exclude[name] = true
  end
end

function M.has_configs()
  local configs = require('lspconfig.configs')

  for _, c in pairs(configs) do
    if c.manager then
      return true
    end
  end

  return false
end

function s.set_capabilities(current)
  if state.capabilities == nil then
    local cmp_default_capabilities = {}
    local base = {}

    if M.has_lspconfig then
      base = require('lspconfig.util').default_config.capabilities
    else
      base = vim.lsp.protocol.make_client_capabilities()
    end

    local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
    if ok then
      M.cmp_capabilities = true
      cmp_default_capabilities = cmp_lsp.default_capabilities()
    end

    state.capabilities = vim.tbl_deep_extend(
      'force',
      base,
      cmp_default_capabilities,
      current or {}
    )

    return state.capabilities
  end

  if current == nil then
    return state.capabilities
  end

  return vim.tbl_deep_extend('force', state.capabilities, current)
end

function s.ensure_capabilities(server_config, user_config)
  local config_def = require('lspconfig.configs')[server_config.name]

  if type(config_def) ~= 'table' then
    return
  end

  local get_completion = function(val)
    return vim.tbl_get(val, 'capabilities', 'textDocument', 'completion')
  end

  local defaults = vim.tbl_get(config_def, 'document_config', 'default_config')
  local default_opts = get_completion(defaults or {})

  if defaults == nil or default_opts == nil then
    return
  end

  local user_opts = get_completion(user_config) or {}
  local plugin_opts = s.set_capabilities().textDocument.completion

  local completion_opts = vim.tbl_deep_extend(
    'force',
    default_opts,
    plugin_opts,
    user_opts
  )

  server_config.capabilities.textDocument.completion = completion_opts
end

function s.map_check(mode, lhs)
  local cache = state.omit_keys[mode][lhs]
  if cache == nil then
    local available = vim.fn.mapcheck(lhs, mode) == ''
    state.omit_keys[mode][lhs] = not available

    return not available
  end

  return cache
end

function s.apply_global_config(config, user_config, defaults)
  local new_config = vim.deepcopy(defaults)
  s.tbl_merge(new_config, user_config)

  for key, val in pairs(new_config) do
    if s.is_keyval(val) and s.is_keyval(config[key]) then
      s.tbl_merge(config[key], val)
    elseif (
      key == 'on_new_config'
      and config[key]
      and config[key] ~= new_config[key]
    ) then
      local cb = config[key]
      config[key] = s.compose_fn(cb, new_config[key])
    else
      config[key] = val
    end
  end
end

function s.compose_fn(config_callback, user_callback)
  return function(...)
    config_callback(...)
    user_callback(...)
  end
end

function s.is_keyval(v)
  return type(v) == 'table' and not vim.tbl_islist(v)
end

function s.tbl_merge(old_val, new_val)
  for k, v in pairs(new_val) do
    if s.is_keyval(old_val[k]) and s.is_keyval(v) then
      s.tbl_merge(old_val[k], v)
    else
      old_val[k] = v
    end
  end
end

return M

