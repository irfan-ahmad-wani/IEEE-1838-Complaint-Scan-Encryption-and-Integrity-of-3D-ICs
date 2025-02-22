`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.01.2025 16:15:21
// Design Name: 
// Module Name: SIPO_decrypt_PISO
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


module SIPO_decrypt_PISO(
input wire  clk ,reset_n_ka, reset_n , start , en , 
     input  wire serial_in , 
     input  wire [127:0] initial_key ,
     //output wire [127:0] plaintext
     output wire  serial_out

    );
    wire [127:0] parallel_data1;
    wire [127:0] parallel_data2;
    
    SIPO_D dut(
   .clk(clk),                   // Clock signal
   .reset_n(reset_n),               // Active-low reset
   .serial_in(serial_in),             // Serial input bit
   .data_out(parallel_data1)       // 128-bit parallel output
        );
    
    decrypt uut_dec(
    .clk(clk) ,
    .reset_n_ka(reset_n_ka), 
    .reset_n(reset_n) , 
    .start(start) , 
    .en(en) , 
    .cyphertext(parallel_data1) , 
    .initial_key(initial_key) ,
    .plaintext(parallel_data2)
        );
        
PISO_D uut (
    .clk(clk),                // Clock signal
    .reset_n(reset_n),            // Active-low reset
    .data_in(parallel_data2),    // 128-bit parallel input
    .serial_out(serial_out)          // Serial output
        );
endmodule
