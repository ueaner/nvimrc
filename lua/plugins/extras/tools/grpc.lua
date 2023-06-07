return {
  -- grpc client
  {
    "hudclark/grpc-nvim",
    ft = "grpc",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Grpc" },
    keys = {
      { "<leader>rg", "<cmd>Grpc<cr>", desc = "gRPC request" },
    },
  },
}
