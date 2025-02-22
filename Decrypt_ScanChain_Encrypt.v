`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.02.2025 17:11:08
// Design Name: 
// Module Name: Decrypt_SC_Encrypt
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Decrypt_Scan_chain_Encrypt(

    input wire tck,reset_n,reset_n_ka,start,en,
    input wire TDI,
    input wire shift_en,update_en,capture_en,
    input wire [127:0] initial_key,
    
    //output wire [127:0] cyphertext
    output wire TDO
    );

wire temp_out;

Decrypt_Scan_chain UUT(
.tck(tck),
.reset_n(reset_n),
.reset_n_ka(reset_n_ka),
.start(start),
.en(en),
.TDI(TDI),
.shift_en(shift_en),
.update_en(update_en),
.capture_en(capture_en),
.initial_key(initial_key),
.TDO(temp_out)
);

SIPO_encrypt_PISO SeP(
.clk(tck),
.reset_n(reset_n),
.serial_in(temp_out),
.en(en),
.start(start),
.initial_key(initial_key),
//.cyphertext(cyphertext)
.serial_out(TDO)
 );
endmodule

