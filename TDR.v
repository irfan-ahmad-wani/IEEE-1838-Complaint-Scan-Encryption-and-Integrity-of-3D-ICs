`timescale 1ns / 1ps


module TDR_Scan_chain(
        input wire tck,reset_n,
        input wire TDI,
        input wire shift_en, update_en, capture_en,
//     wire [127:0] to_core;
//     wire [127:0] from_core;     
        output wire TDO
        
);

wire [0:126] temp;
wire [127:0] to_core;
wire [127:0] from_core;
 
 
 inverter inverters (
    .a(to_core),
    .y(from_core)  // Inverted output
);

TDR TDR0 (
        .tck(tck),
        .reset_n(reset_n) ,           
        .shift_en(shift_en),
        .update_en(update_en), 
        .capture_en(capture_en),   
        .ScanIn(TDI),  
        .ScanOut(temp[0]),   
        .From_Core(from_core[0]), 
        .To_core(to_core[0])
);

genvar i;
	
for (i = 1; i <= 126; i = i + 1) begin
TDR TD_$i (
        .tck(tck),
        .reset_n(reset_n) ,           
        .shift_en(shift_en),
        .update_en(update_en), 
        .capture_en(capture_en),   
        .ScanIn(temp[i-1]),  
        .ScanOut(temp[i]),   
        .From_Core(from_core[i]), 
        .To_core(to_core[i])
);	
		end
TDR TDR127 (
        .tck(tck),
        .reset_n(reset_n) ,           
        .shift_en(shift_en),
        .update_en(update_en), 
        .capture_en(capture_en),   
        .ScanIn(temp[126]),  
        .ScanOut(TDO),   
        .From_Core(from_core[127]), 
        .To_core(to_core[127])
);
	
endmodule
//------------1 Bit TDR-------------------------------------------------------//
module TDR
   ( input   wire tck,reset_n ,           
     input   wire shift_en, update_en, capture_en,   
             wire ScanIn,  ScanOut,   
             wire From_Core, To_core
    
       
     );
     
     wire mux_1_out,mux_2_out,mux_3_out;
mux2x1 capt_mux (.s_in(capture_en), .in_0(ScanOut), .in_1(From_Core), .mux_out(mux_1_out));
mux2x1 shift_mux (.s_in(shift_en), .in_0(mux_1_out), .in_1(ScanIn), .mux_out(mux_2_out));
mux2x1 update_mux (.s_in(update_en), .in_0(To_core), .in_1(ScanOut), .mux_out(mux_3_out));

Register capt_shift_reg (.in(mux_2_out), .clk(tck) , .out(ScanOut));
Register update_reg (.in(mux_3_out), .clk(!tck), .reset_n(reset_n), .out(To_core));   
     
endmodule
