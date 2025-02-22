

module encrypt (
     input  wire clk , reset_n , start , en , 
     input  wire [127:0]plaintext , initial_key ,
     output reg [127:0]cyphertext
);
parameter [1:0]CTRL_IDLE = 2'b00 , CTRL_MAIN = 2'b01 , CTRL_FINAL = 2'b10 ;
reg [1:0]round_ctrl_reg, round_ctrl_new , round_nm_inc ;
reg [3:0]round_nm_reg , round_nm_new , round_nm_rst;
reg [127:0]block_reg , block_new ;
wire [127:0]keyExpanOut ;
reg [127:0]bsIn ;
wire [127:0]bsOut ;

 BS bs_inst(bsIn , bsOut) ;
 keyExpan ka_inst(clk , en , round_nm_reg , initial_key , reset_n , keyExpanOut ) ;

always @(posedge clk)begin
     if(~reset_n)begin
          round_ctrl_reg <= CTRL_IDLE ;
          round_nm_reg <= 4'bx ;
     end
     else begin
          round_ctrl_reg <= round_ctrl_new ;
          round_nm_reg <= round_nm_new ;
          bsIn <= block_new ;
          block_reg <= block_new ;

     end
end
always @ * 

begin
     round_nm_new =  4'bx ;
     if(round_nm_rst)
     round_nm_new = 1 ;
     else if(round_nm_inc)
     round_nm_new = round_nm_reg + 1 ;
end
always @ * begin : round_control_fsm
     reg [127:0]KAInitOut , BSOut , SROut , MCOut , KAFinalOut ;
     round_nm_rst = 0 ;
     KAInitOut = plaintext ^ initial_key ;
     case(round_ctrl_reg)
     CTRL_IDLE : begin
          if(start)begin
               round_ctrl_new = CTRL_MAIN ;
               round_nm_rst = 1 ;
               block_new = KAInitOut ;
          end

     end
     CTRL_MAIN : begin
          BSOut = bsOut ;
          SROut = shiftrows(BSOut) ;
          MCOut = mixcolumns(SROut) ;
          block_new = MCOut ;
          block_new = addKey(MCOut , keyExpanOut) ;
          round_nm_inc = 1 ;
          round_ctrl_new = (round_nm_reg < 9)?CTRL_MAIN : CTRL_FINAL ;
          
          // bsIn = MCOut ; // this line is creating an issue since this 
          // creates a combinational feedback loop . good stuff

     end
     CTRL_FINAL : begin
          BSOut = bsOut ;
          SROut = shiftrows(BSOut) ;
         
          block_new = addKey(SROut , keyExpanOut) ;
          round_nm_rst = 1 ;
          round_ctrl_new = CTRL_IDLE ;
          cyphertext = block_new ;
     end
     endcase
end

function automatic [127 : 0] shiftrows(input [127 : 0] data);
    reg [31 : 0] w0, w1, w2, w3;
    reg [31 : 0] ws0, ws1, ws2, ws3;
    begin
      w0 = data[127 : 096];
      w1 = data[095 : 064];
      w2 = data[063 : 032];
      w3 = data[031 : 000];

      ws0 = {w0[31 : 24], w1[23 : 16], w2[15 : 08], w3[07 : 00]};
      ws1 = {w1[31 : 24], w2[23 : 16], w3[15 : 08], w0[07 : 00]};
      ws2 = {w2[31 : 24], w3[23 : 16], w0[15 : 08], w1[07 : 00]};
      ws3 = {w3[31 : 24], w0[23 : 16], w1[15 : 08], w2[07 : 00]};

      shiftrows = {ws0, ws1, ws2, ws3};
    end
  endfunction // shiftrows
     


function automatic [127:0]addKey(input [127:0]in ,input[127:0]key );
     addKey = in ^ key ;
endfunction

function automatic [31:0]mixw(input [31:0]w) ;

    reg [7 : 0] b0, b1, b2, b3;
    reg [7 : 0] mb0, mb1, mb2, mb3;
    begin
      b0 = w[31 : 24];
      b1 = w[23 : 16];
      b2 = w[15 : 08];
      b3 = w[07 : 00];

      mb0 = gm2(b0) ^ gm3(b1) ^ b2      ^ b3;
      mb1 = b0      ^ gm2(b1) ^ gm3(b2) ^ b3;
      mb2 = b0      ^ b1      ^ gm2(b2) ^ gm3(b3);
      mb3 = gm3(b0) ^ b1      ^ b2      ^ gm2(b3);

      mixw = {mb0, mb1, mb2, mb3};
end
endfunction

function automatic [127 : 0] mixcolumns(input [127 : 0] data);
    reg [31 : 0] w0, w1, w2, w3;
    reg [31 : 0] ws0, ws1, ws2, ws3;
    begin
      w0 = data[127 : 096];
      w1 = data[095 : 064];
      w2 = data[063 : 032];
      w3 = data[031 : 000];

      ws0 = mixw(w0);
      ws1 = mixw(w1);
      ws2 = mixw(w2);
      ws3 = mixw(w3);

      mixcolumns = {ws0, ws1, ws2, ws3};
    end
  endfunction // mixcolumns


// Multiply by 2 in GF(2^8) for AES
    function [7:0] gm2;
        input [7:0] x;
        begin
            if (x[7] == 1) 
                gm2 = (x << 1) ^ 8'h1b; // x * 2 in GF(2^8)
            else 
                gm2 = x << 1;
        end
    endfunction

    // Multiply by 3 in GF(2^8) for AES
    function [7:0] gm3;
        input [7:0] x;
        begin
            gm3 = gm2(x) ^ x; // x * 3 = (x * 2) + x
        end
    endfunction
     
endmodule