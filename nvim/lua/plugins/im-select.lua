return {
  {
    "keaising/im-select.nvim",
    event = "VeryLazy",
    opts = {
      default_command = "macism",
      default_im_select = "com.apple.keylayout.US",
      set_default_events = { "InsertLeave", "CmdlineLeave" },
      set_previous_events = { "InsertEnter" },
      keep_quiet_on_no_binary = false,
      async_switch_im = true,
    },
  },
}
