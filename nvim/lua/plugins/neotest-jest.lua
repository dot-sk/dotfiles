local function find_package_json(startpath)
  local package_json = vim.fs.find("package.json", {
    upward = true,
    path = startpath,
  })[1]

  return package_json and vim.fs.dirname(package_json) or vim.uv.cwd()
end

local function has_script(package_root, script)
  local package_json = package_root and vim.fs.joinpath(package_root, "package.json")
  if not package_json then
    return false
  end

  local ok, package = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(package_json), "\n"))
  return ok and package and package.scripts and package.scripts[script] ~= nil
end

local function get_jest_command(file)
  local package_root = find_package_json(file)

  if has_script(package_root, "test:unit") then
    return "npm run test:unit --"
  end

  if has_script(package_root, "test") then
    return "npm test --"
  end

  return "npx jest"
end

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-jest",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      opts.adapters["neotest-jest"] = {
        cwd = function(file)
          return find_package_json(file)
        end,
        jestCommand = function(file)
          return get_jest_command(file)
        end,
        jest_test_discovery = false,
      }
    end,
  },
}
