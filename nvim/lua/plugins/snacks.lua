return {
  {
    "folke/snacks.nvim",
    opts = {
      gitbrowse = {
        url_patterns = {
          ["gitlab%.tcsbank%.ru"] = {
            branch = "/-/tree/{branch}",
            file = "/-/blob/{branch}/{file}#L{line_start}-{line_end}",
            permalink = "/-/blob/{commit}/{file}#L{line_start}-{line_end}",
            commit = "/-/commit/{commit}",
          },
        },
      },
      picker = {
        sources = {
          explorer = {
            hidden = true,
          },
          files = {
            hidden = true,
          },
        },
      },
    },
  },
}
