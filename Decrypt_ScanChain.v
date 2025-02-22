`timescale 1ns / 1ps




//////////////////////////////////////////////////////////////////////////////////


module Decrypt_Scan_chain(
input wire tck,reset_n,reset_n_ka,start,en,
input wire TDI,
input wire shift_en,update_en,capture_en,
input wire [127:0] initial_key,

output wire TDO
);


wire serial_out_tdi;
    
     SIPO_decrypt_PISO SDP(
        .clk(tck),
        .reset_n_ka(reset_n_ka),
        .reset_n(reset_n),
        .start(start), 
        .en(en), 
        .serial_in(TDI), 
        .initial_key(initial_key),
        .serial_out(serial_out_tdi)
        //.serial_out(TDO)
    
        );
    TDR_Scan_chain SC(
        .tck(tck),
        .reset_n(reset_n),
        .TDI(serial_out_tdi),
        .shift_en(shift_en), 
        .update_en(update_en), 
        .capture_en(capture_en),
        .TDO(TDO)
        
);
endmodule
