return {
  {
    "2kabhishek/octohub.nvim",
    cmd = { "Octohub" },
    keys = { "<leader>goo" },
    dependencies = {
      "2kabhishek/utils.nvim",
      "2kabhishek/pickme.nvim",
    },
    opts = {
      icons = {
        user = " ",
        star = " ",
        contribution_icons = { "", "", "", "", "", "", "" },
      },
      repos = {
        per_user_dir = true, -- Create a directory for each user
        projects_dir = "~/Projects/", -- Directory where repositories are cloned
        sort_by = "", -- Sort repositories by various parameters
        repo_type = "", -- Type of repositories to display
        language = "", -- Repositories language filter
      },
      stats = {
        max_contributions = 50, -- Max number of contributions per day to use for icon selection
        top_lang_count = 5, -- Number of top languages to display in stats
        event_count = 5, -- Number of activity events to show
        window_width = 90, -- Width in percentage of the window to display stats
        window_height = 60, -- Height in percentage of the window to display stats
        show_recent_activity = true, -- Show recent activity in the stats window
        show_contributions = true, -- Show contributions in the stats window
        show_repo_stats = true, -- Show repository stats in the stats window
      },
      cache = {
        events = 3600 * 6, -- Time in seconds to cache activity events (6 hours)
        contributions = 3600 * 6, -- Time in seconds to cache contributions data (6 hours)
        repos = 3600 * 24 * 7, -- Time in seconds to cache repositories (7 days)
        username = 3600 * 24 * 7, -- Time in seconds to cache username (7 days)
        user = 3600 * 24 * 7, -- Time in seconds to cache user data (7 days)
      },
      add_default_keybindings = true, -- Add default keybindings for the plugin
    },
  },
}
