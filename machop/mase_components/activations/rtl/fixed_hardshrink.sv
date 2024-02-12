`timescale 1ns / 1ps
module fixed_hardshrink #(
    /* verilator lint_off UNUSEDPARAM */
    parameter DATA_IN_0_PRECISION_0 = 8,
    parameter DATA_IN_0_PRECISION_1 = 4,
    parameter DATA_IN_0_TENSOR_SIZE_DIM_0 = 10,
    parameter DATA_IN_0_TENSOR_SIZE_DIM_1 = 1,
    parameter DATA_IN_0_PARALLELISM_DIM_0 = 1,
    parameter DATA_IN_0_PARALLELISM_DIM_1 = 1,

    parameter DATA_OUT_0_PRECISION_0 = 8,
    parameter DATA_OUT_0_PRECISION_1 = 4,
    parameter DATA_OUT_0_TENSOR_SIZE_DIM_0 = 10,
    parameter DATA_OUT_0_TENSOR_SIZE_DIM_1 = 1,
    parameter DATA_OUT_0_PARALLELISM_DIM_0 = 1,
    parameter DATA_OUT_0_PARALLELISM_DIM_1 = 1,
    parameter LAMBDA = 0.5, //the threshold
    parameter FX_LAMBDA = $rtoi(LAMBDA * 2**(DATA_IN_0_PRECISION_1)), //the threshold

    parameter INPLACE = 0
) (
    /* verilator lint_off UNUSEDSIGNAL */
    input rst,
    input clk,
    input logic [DATA_IN_0_PRECISION_0-1:0] data_in_0[DATA_IN_0_PARALLELISM_DIM_0*DATA_IN_0_PARALLELISM_DIM_1-1:0],
    output logic [DATA_OUT_0_PRECISION_0-1:0] data_out_0[DATA_OUT_0_PARALLELISM_DIM_0*DATA_OUT_0_PARALLELISM_DIM_1-1:0],

    input  logic data_in_0_valid,
    output logic data_in_0_ready,
    output logic data_out_0_valid,
    input  logic data_out_0_ready
);
  logic [DATA_IN_0_PRECISION_0-1:0] fx_lambda;

  for (genvar i = 0; i < DATA_IN_0_TENSOR_SIZE_DIM_0; i++) begin : ReLU
    always_comb begin
      // negative value, put to zero
      // fx_lambda = LAMBDA << DATA_IN_0_PRECISION_1;
      if ($signed(data_in_0[i]) < -1 *FX_LAMBDA) data_out_0[i] = data_in_0[i];
      else if($signed(data_in_0[i]) > FX_LAMBDA ) data_out_0[i] = data_in_0[i];
      else data_out_0[i] = '0;
    end
  end
  
  assign data_out_0_valid = data_in_0_valid;
  assign data_in_0_ready  = data_out_0_ready;

endmodule
