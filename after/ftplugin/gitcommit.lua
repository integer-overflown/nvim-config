local nio = require("nio")

nio.run(function()
  local process, err = nio.process.run({
    cmd = "git",
    args = { "branch", "--show-current" },
  })

  local e = function(message)
    vim.schedule(function()
      vim.notify("Failed to query the current branch: " .. message, vim.log.levels.ERROR)
    end)
    process.close()
  end

  if not process then
    e(err)
  end

  local exit_code = process.result(false)

  if exit_code ~= 0 then
    e("non-zero exit code")
  end

  local branch_name = process.stdout.read()

  local conf = require("utils.config")
  local task_template = conf.read_field(conf.load_config().wait(), "string", "git", "task_template")
  local message_template = conf.read_field(conf.load_config().wait(), "string", "git", "message_template")

  if not (task_template and message_template) then
    -- There's no data to auto-fill, but let's save pressing a single letter and
    -- enter insert mode anyway
    vim.schedule(function()
      vim.cmd("startinsert!")
    end)
    return
  end

  local task = string.match(branch_name, task_template)

  if not task then
    return
  end

  local message = string.gsub(message_template, "%$task", task)

  vim.schedule(function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, 1, true)
    assert(#lines > 0)

    -- don't overwrite the contents if there is already a message
    -- (for example, when amending, rebasing or merging)
    -- git leaves the first line empty for user's message if one is required,
    -- so we can rely on its length.
    if #lines[1] == 0 then
      vim.api.nvim_buf_set_lines(0, 0, 1, true, { message })
      vim.cmd("startinsert!")
    end
  end)

  process.close()
end)
