
module decrypt (
     input wire  clk ,reset_n_ka, reset_n , start , en , 
     input  wire [127:0]cyphertext , initial_key ,
     output reg [127:0]plaintext
);
parameter [1:0]CTRL_IDLE = 2'b00 , CTRL_MAIN = 2'b01 , CTRL_FINAL = 2'b10 ;
reg [1:0]round_ctrl_reg , round_ctrl_new ;
reg [3:0]round_nm_reg , round_nm_new ;
reg round_nm_rst , round_nm_dec ;
wire[127:0]keyExpanOut ;
reg [127:0]invbsIn ;
wire [127:0]invbsOut ;
reg [127:0]block_reg , block_new ;


invBS invBS_inst(invbsIn , invbsOut) ;
keyExpan ka_inst(clk , en , round_nm_reg , initial_key , reset_n_ka , keyExpanOut ) ;

always @(posedge clk)begin
     if(~reset_n)begin
          round_ctrl_reg <= CTRL_IDLE ;
          round_nm_reg <= 4'bx ;
          block_reg <= 128'bx ;
     end
     else begin
          round_nm_reg <= round_nm_new ;
          round_ctrl_reg <= round_ctrl_new ;
          block_reg <= invbsOut ;
          if(round_nm_reg == 1)plaintext <= addroundkey(invbsOut , initial_key)  ;

     end
end
always @(*)begin
     round_nm_new = 4'bx ;
     if(round_nm_rst )round_nm_new = 10 ;
     else if(round_nm_dec)round_nm_new = round_nm_reg - 1 ;
end
always @ * begin : control_fsm
     reg [127:0]invSRFinalOut , invMCOut , invSROut , invBSOut , KAOut;
     round_nm_rst = 0 ;
     case(round_ctrl_reg)
     CTRL_IDLE : begin
          if(start)begin
               round_ctrl_new = CTRL_FINAL ;
               round_nm_rst = 1 ;
          end
     end
     CTRL_FINAL : begin
          KAOut = addroundkey(cyphertext , keyExpanOut) ;
          invSRFinalOut = inv_shiftrows(KAOut) ;
          invbsIn = invSRFinalOut ;
          round_nm_dec = 1 ;
          round_ctrl_new = CTRL_MAIN ;
     end
     CTRL_MAIN : begin
          KAOut = addroundkey(block_reg , keyExpanOut) ;
          invMCOut = inv_mixcolumns(KAOut) ;
          invSROut = inv_shiftrows(invMCOut) ;
          invbsIn = invSROut ;
          if(round_nm_reg != 1)
          round_nm_dec = 1 ;
          else 
          round_nm_dec = 0 ; 
          round_ctrl_new = (round_nm_reg == 1) ? CTRL_IDLE : CTRL_MAIN ;
     end
     endcase
end

function automatic [7 : 0] gm2(input [7 : 0] op);
    begin
      gm2 = {op[6 : 0], 1'b0} ^ (8'h1b & {8{op[7]}});
    end
  endfunction // gm2

  function automatic [7 : 0] gm3(input [7 : 0] op);
    begin
      gm3 = gm2(op) ^ op;
    end
  endfunction // gm3

  function automatic [7 : 0] gm4(input [7 : 0] op);
    begin
      gm4 = gm2(gm2(op));
    end
  endfunction // gm4

  function automatic [7 : 0] gm8(input [7 : 0] op);
    begin
      gm8 = gm2(gm4(op));
    end
  endfunction // gm8

  function automatic [7 : 0] gm09(input [7 : 0] op);
    begin
      gm09 = gm8(op) ^ op;
    end
  endfunction // gm09

  function automatic [7 : 0] gm11(input [7 : 0] op);
    begin
      gm11 = gm8(op) ^ gm2(op) ^ op;
    end
  endfunction // gm11

  function automatic [7 : 0] gm13(input [7 : 0] op);
    begin
      gm13 = gm8(op) ^ gm4(op) ^ op;
    end
  endfunction // gm13

  function automatic [7 : 0] gm14(input [7 : 0] op);
    begin
      gm14 = gm8(op) ^ gm4(op) ^ gm2(op);
    end
  endfunction // gm14

  function automatic [31 : 0] inv_mixw(input [31 : 0] w);
    reg [7 : 0] b0, b1, b2, b3;
    reg [7 : 0] mb0, mb1, mb2, mb3;
    begin
      b0 = w[31 : 24];
      b1 = w[23 : 16];
      b2 = w[15 : 08];
      b3 = w[07 : 00];

      mb0 = gm14(b0) ^ gm11(b1) ^ gm13(b2) ^ gm09(b3);
      mb1 = gm09(b0) ^ gm14(b1) ^ gm11(b2) ^ gm13(b3);
      mb2 = gm13(b0) ^ gm09(b1) ^ gm14(b2) ^ gm11(b3);
      mb3 = gm11(b0) ^ gm13(b1) ^ gm09(b2) ^ gm14(b3);

      inv_mixw = {mb0, mb1, mb2, mb3};
    end
  endfunction // mixw

  function automatic [127 : 0] inv_mixcolumns(input [127 : 0] data);
    reg [31 : 0] w0, w1, w2, w3;
    reg [31 : 0] ws0, ws1, ws2, ws3;
    begin
      w0 = data[127 : 096];
      w1 = data[095 : 064];
      w2 = data[063 : 032];
      w3 = data[031 : 000];

      ws0 = inv_mixw(w0);
      ws1 = inv_mixw(w1);
      ws2 = inv_mixw(w2);
      ws3 = inv_mixw(w3);

      inv_mixcolumns = {ws0, ws1, ws2, ws3};
    end
  endfunction // inv_mixcolumns

  function automatic [127 : 0] inv_shiftrows(input [127 : 0] data);
    reg [31 : 0] w0, w1, w2, w3;
    reg [31 : 0] ws0, ws1, ws2, ws3;
    begin
      w0 = data[127 : 096];
      w1 = data[095 : 064];
      w2 = data[063 : 032];
      w3 = data[031 : 000];

      ws0 = {w0[31 : 24], w3[23 : 16], w2[15 : 08], w1[07 : 00]};
      ws1 = {w1[31 : 24], w0[23 : 16], w3[15 : 08], w2[07 : 00]};
      ws2 = {w2[31 : 24], w1[23 : 16], w0[15 : 08], w3[07 : 00]};
      ws3 = {w3[31 : 24], w2[23 : 16], w1[15 : 08], w0[07 : 00]};

      inv_shiftrows = {ws0, ws1, ws2, ws3};
    end
  endfunction // inv_shiftrows

  function automatic [127 : 0] addroundkey(input [127 : 0] data, input [127 : 0] rkey);
    begin
      addroundkey = data ^ rkey;
    end
  endfunction // addroundkey

endmodule