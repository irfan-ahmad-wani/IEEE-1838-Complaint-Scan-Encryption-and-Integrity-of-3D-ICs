`timescale 1ns / 1ps


module tb_SIPO_decrypt_PISO ();
    reg clk, reset_n_ka, reset_n, start, en;
    reg serial_in;
    reg [127:0] test_serial_in = 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
    reg [127:0] test_key = 128'h0123456789abcdef0123456789abcdef;
    reg [127:0] initial_key;
   //wire [127:0] plaintext;
    wire serial_out;
    integer clock_counter;   // Counter to track clock cycles after reset_n is enabled
    integer i;
    SIPO_decrypt_PISO uut (
        .clk(clk),
        .reset_n_ka(reset_n_ka),
        .reset_n(reset_n),
        .start(start),
        .en(en),
        .serial_in(serial_in),
        .initial_key(initial_key),
        //.plaintext(plaintext)
        .serial_out(serial_out)
    );

    // Clock generation
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
    // Testbench sequence
    initial begin
        reset_n = 0;
        reset_n_ka = 0;
        start = 0;
        en = 0;
        clk=0;
        serial_in = 0;  // Initialize serial input
        initial_key = test_key;
    #10;
         reset_n_ka = 1;
         start = 1 ;
         en = 1 ;
         #110
         reset_n = 1 ;
    #60;
        // Apply serial input bit-by-bit at each clock cycle and track cycles
        for (i = 127; i >= 0; i = i - 1) begin
            @(posedge clk);
            serial_in = test_serial_in[i];
        end
        serial_in = 0;
         // Extra wait time to observe output
       
    end


   
endmodule
