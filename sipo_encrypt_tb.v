`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2025 14:55:47
// Design Name: 
// Module Name: tb_SIPO_encryp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for SIPO_encryp module
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_SIPO_encrypt_PISO;

    // Inputs
    reg clk;
    reg reset_n;
    reg serial_in;
    reg en;
    reg start;
    reg [127:0] initial_key;

    // Outputs
   wire serial_out;

//wire [127:0] cyphertext;
    // Instantiate the SIPO_encryp module
    SIPO_encrypt_PISO uut (
        .clk(clk),
        .reset_n(reset_n),
        .serial_in(serial_in),
        .en(en),
        .start(start),
        .initial_key(initial_key),
        .serial_out(serial_out)
    );


    integer clock_counter;    // Counter to track clock cycles

    // Clock Generation
    always begin
        #5 clk = ~clk;  // Generate clock signal with 10 ns period
    end

    // Count Clock Cycles
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            clock_counter <= 0;  // Reset the counter to 0
        else
            clock_counter <= clock_counter + 1;  // Increment counter on every rising edge
    end

    // Stimulus block
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        serial_in = 0;
        en = 0;
        start = 0;
        clock_counter = 0;  // Initialize clock cycle counter
        
        #10;
        en = 1;
        start = 1;
        reset_n = 1;
        initial_key = 128'h0123456789abcdef0123456789abcdef; // Example 128-bit key
        
        
       #60

        // Apply the serial input `0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA`
        begin
    serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
 #10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;

#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;
#10 serial_in = 1;
#10 serial_in = 0;


        end

        
         
        serial_in = 0; 

        
        // End the simulation
        $finish;
        end
endmodule
