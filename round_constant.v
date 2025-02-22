`ifndef ROUND_CF_V
`define ROUND_CF_V
module round_cf(
input wire [3:0] r,
output reg [31:0] cf  
);

always @(*)
 case(r)
    4'h1: cf=32'h01000000;
    4'h2: cf=32'h02000000;
    4'h3: cf=32'h04000000;
    4'h4: cf=32'h08000000;
    4'h5: cf=32'h10000000;
    4'h6: cf=32'h20000000;
    4'h7: cf=32'h40000000;
    4'h8: cf=32'h80000000;
    4'h9: cf=32'h1b000000;
    4'ha: cf=32'h36000000;
    default: cf=32'h00000000;
  endcase
endmodule
`endif 