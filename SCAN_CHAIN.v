`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.02.2025 16:17:26
// Design Name: 
// Module Name: Scan_chain
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
///-------------------Mux----------------------------------------------------------
module mux2x1(s_in,in_0,in_1,mux_out);
    input wire  in_0,in_1;
    input wire s_in;
    output reg  mux_out;
    
    always @(*)
    begin
        if(s_in == 0)
            mux_out <= in_0;
        else
            mux_out <= in_1;
    end
endmodule 


//------------------------Register-----------------------
    
module Register(
        input wire in,reset_n,clk,
        output wire out
         );
         reg R;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            R <= 1'b0; // Reset the register when reset_n is low
        else
            R <= in;
    end

    assign out = R;
endmodule

//---------------------inverter--------------------
module inverter (
    input wire [127:0] a,  // Input signal
    output wire [127:0] y
      // Inverted output
);

assign y = a ;
    
endmodule

