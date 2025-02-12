-- Load globals
require("config.globals")

-- Configure global vim options
require("config.options")

-- Load Lazy and the plugins
require("config.lazy")

-- Configure keyboard maps, now that all plugins are accessible
require("config.keymaps")

-- Configure extensions specific to this config (various custom keymaps, overrides, windows, pickers, etc.)
require("extensions")
