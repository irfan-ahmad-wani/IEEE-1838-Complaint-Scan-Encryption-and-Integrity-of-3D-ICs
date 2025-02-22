`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2025 14:55:47
// Design Name: 
// Module Name: SIPO_encryp
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


module SIPO_encrypt_PISO(
input wire clk,reset_n,serial_in,en, start,
input wire [127:0] initial_key,

//output wire[127:0] cyphertext

output wire serial_out

    );
wire [127:0] parallel_data1,parallel_data2;



SIPO sipo_uut (
    .clk(clk),                   // Clock signal
    .reset_n(reset_n),               // Active-low reset
    .serial_in(serial_in),             // Serial input bit
    .data_out(parallel_data1)
      
);

encrypt enc_uut (
     .clk (clk),
     .reset_n(reset_n), 
     .start (start), 
     .en(en),
     .plaintext(parallel_data1) , 
     .initial_key(initial_key) ,
     .cyphertext(parallel_data2)
);
PISO PISO_uut (
    .clk(clk),                    // Clock signal
    .reset_n(reset_n),                // Active-low reset
    .data_in(parallel_data2),        // 128-bit parallel input
    .serial_out(serial_out)              // Serialized output
);
endmodule