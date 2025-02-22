
`ifndef KEYEXPAN_V
`define KEYEXPAN_V


module keyExpan ( //
     input wire clk , en ,
     input wire [3:0]round , 
    input wire [127:0] initial_key, 
    input  wire reset_n , 
    output wire [127:0]round_key        
);
// should get round i key at 128*(i+1) - 1 -: 128 
reg [1407:0] key_reg ;
reg round_nm_rst ;
parameter num_rounds = 10 ; 
reg [1:0]state , next_state ; 
parameter CTRL_IDLE = 2'b00 ,CTRL_INIT = 2'b01 ,  CTRL_MAIN = 2'b10 ;
reg [3:0]round_nm_reg , round_nm_new ;
reg round_nm_we ;
reg round_nm_inc ;
reg [1:0]round_ctrl_reg , round_ctrl_new ; 
reg round_ctrl_we;
reg [127:0]round_key_reg , round_key_new  ;
reg round_key_we ;
reg [127:0]old_round_key , old_round_key_new ;
reg old_round_key_we ;
reg done = 0 ;
reg [31:0]byteSubIn ; 
wire [31:0]byteSubOut , roundCfOut;
byteSub bs_inst(.in(byteSubIn), .out(byteSubOut)) ;
round_cf rcf_inst(.r(round_nm_reg) , .cf(roundCfOut)) ;


assign round_key = (round >= 1 && round <= 10) ? key_reg[128*(round+1) - 1 -: 128] : 128'bx;

always @(posedge clk ) begin
     if(~reset_n)begin
          round_ctrl_reg <= 0 ;
          round_key_reg <= 0 ;
          old_round_key <=0 ;
          round_nm_reg <= 0 ;
          round_ctrl_reg <= CTRL_IDLE ;
     end
     else begin
          if(round_nm_we)
          round_nm_reg <= round_nm_new ;
          if(round_ctrl_we)
          round_ctrl_reg <= round_ctrl_new ;
          if(round_key_we)
          round_key_reg <= round_key_new ;
          if(old_round_key_we)
          old_round_key <= old_round_key_new ;
     end
end

always @ * begin // round control reg
     round_nm_new = 0 ;
     round_nm_we = 0 ;
     if(round_nm_rst)begin
          round_nm_new = 0 ;
          round_nm_we = 1 ;
     end
     else begin
          if(round_nm_inc)begin
          round_nm_new = round_nm_reg + 1 ;
          round_nm_we  = 1 ;
          end
     end
end

always @ * 
     begin : round_control
     reg [31:0]circ , circSub , xored ;
     round_nm_rst = 0 ;
     round_nm_inc = 0 ;
     round_ctrl_we = 0 ;
     

     case(round_ctrl_reg) 
     CTRL_IDLE :  begin
          if(en && ~done)begin
               
               round_key_new = initial_key ;
               round_key_we  = 1 ;

               old_round_key_new = round_key_new ;
               old_round_key_we = 1 ;
               
               key_reg[128*(round_nm_reg+1) -1 -: 128 ] = initial_key;

               round_nm_inc = 1 ;
               
               round_ctrl_new = CTRL_MAIN ;
               round_ctrl_we = 1 ; 
               circ = {old_round_key[23:0] , old_round_key[31 -: 8]} ;
               byteSubIn = circ ;
               
          end
     end
     CTRL_MAIN : begin
          // use old_round_key and make the new keys and keep storing
          circSub =  byteSubOut ;
          xored = circSub ^ roundCfOut ;
          round_key_new[127 -: 32] = old_round_key[127 -: 32] ^ xored ;
          round_key_new[127 - 32 -: 32] = old_round_key[127 - 32 -: 32] ^  round_key_new[127 -: 32];
          round_key_new[127 - 2*32 -: 32] = old_round_key[127 - 2*32 -: 32] ^ round_key_new[127 - 32 -: 32] ;
          round_key_new[127 - 3*32 -: 32] = old_round_key[127 - 3*32 -: 32] ^ round_key_new[127 - 2*32 -: 32] ;
          round_key_we = 1 ;
          
          old_round_key_new = round_key_new ;
          old_round_key_we = 1 ;

          key_reg[128*(round_nm_reg+1) -1 -: 128 ] = round_key_new;
          if(round_nm_reg <= 9)begin
               round_ctrl_new = CTRL_MAIN ;
          end
          else begin
               round_ctrl_new = CTRL_IDLE ;
               done = 1 ;
          end
          round_ctrl_new = (round_nm_reg <= 9) ? CTRL_MAIN : CTRL_IDLE ;
          circ = {old_round_key[23:0] , old_round_key[31 -: 8]} ;
          byteSubIn = circ ;
          round_ctrl_we = 1 ;
          round_nm_inc = 1 ;
          
     end
     endcase
end



endmodule
`endif 
