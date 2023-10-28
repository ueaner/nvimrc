return {
  -- grpc client
  {
    "hudclark/grpc-nvim",
    ft = "grpc",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Grpc" },
    -- keys = {
    --   { "<leader>rr", "<cmd>Grpc<cr>", desc = "Run gRPC request", ft = "grpc" },
    -- },
    init = function()
      -- stylua: ignore
      require("utils").on_ft("grpc", function(event)
        vim.keymap.set("n", "<leader>rr", "<cmd>Grpc<cr>", { desc = "Run gRPC request", buffer = event.buf })
      end)
    end,
  },
}
