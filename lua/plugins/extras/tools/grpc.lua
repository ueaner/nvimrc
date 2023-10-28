return {
  -- grpc client
  {
    "hudclark/grpc-nvim",
    ft = "grpc",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Grpc" },
    keys = {
      { "<leader>rr", "<cmd>Grpc<cr>", desc = "Run gRPC request", ft = "grpc" },
    },
  },
}
