`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.02.2025 17:12:54
// Design Name: 
// Module Name: tb_de_sc_en
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



module tb_tap_de_sc_en;

    reg tck, trst_n, reset_n_ka, start, en,tms;
    reg TDI;
    reg [127:0] initial_key;
    wire TDO;
    wire  shift_en,update_en,capture_en;
    integer i;
    
    reg [127:0] test_serial_in = 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
    reg [31:0] cycle_count; // Counter to track clock cycles after reset_n is high

 TAP_En_SC_De uut (
        .tck(tck),
        .trst_n(trst_n),
        .reset_n_ka(reset_n_ka),
        .start(start),
        .en(en),
        .TDI(TDI),
        .tms(tms),
        .shift_en(shift_en),
        .update_en(update_en),
        .capture_en(capture_en),
        .initial_key(initial_key),
        .TDO(TDO)
        //.cyphertext(cyphertext)
);

    // Generate clock with a period of 10ns (100MHz)
    always #5 tck = ~tck;

    // Counter to track clock cycles after reset_n is high
    always @(posedge tck) begin
        if (trst_n) begin
            cycle_count <= cycle_count + 1; // Increment cycle_count when reset_n is high
        end else begin
            cycle_count <= 0; // Reset cycle_count when reset_n is low
        end
    end

    initial begin
        // Initialize signals
        tck = 0;
        trst_n = 0;
        reset_n_ka = 0;
        start = 0;
        en = 0;
        TDI = 0;
       
        initial_key = 128'h0123456789abcdef0123456789abcdef;
        cycle_count = 0; 
        

        // Apply reset sequence
        #10;
        reset_n_ka = 1;
        en = 1;
        start = 1; 
        #110;
        trst_n = 1;
        #10;
        tms = 1;
        #10;
        tms = 0;
        #10;
        tms = 1;
        #10;
        tms = 0;
        #20;   

        // Shift in test data
        for (i = 127; i >= 0; i = i - 1) begin
            TDI = test_serial_in[i];
            #10; // Assuming one bit per clock cycle
        end
        #230;
        tms=0;
        #1280;
        tms =1;
        #10;
        tms =1;
        #10;
        tms =1;
        #10;
        tms =0;
        #10;
        tms =0;
        #4000;

//        update_en = 1;
//        shift_en = 0;
//        #10;

//        capture_en = 1;
//        update_en = 0;
//        shift_en = 0;    
//        #10;

//        shift_en = 1;
//        update_en = 0;
//        capture_en = 0;
//        #1300;
        $stop;
        // Display the total number of clock cycles after reset_n is high
        $display("Total clock cycles after reset_n is high: %0d", cycle_count);

       
    end
endmodule