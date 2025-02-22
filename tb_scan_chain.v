`timescale 1ns / 1ps

module TDR_Scan_chain_tb;

    // Testbench signals
    reg tck, reset_n;
    reg TDI;
    reg shift_en, update_en, capture_en;
    wire TDO;
    
    reg [127:0] test_data = 128'hffff0000ffff0000ffff0000ffff0000; // Sample test pattern
    integer i;

    // DUT Instantiation
    TDR_Scan_chain uut (
        .tck(tck),
        .reset_n(reset_n),
        .TDI(TDI),
        .shift_en(shift_en),
        .update_en(update_en),
        .capture_en(capture_en),
        .TDO(TDO)
    );

    // Clock Generation (50MHz -> 20ns period)
    always #5 tck = ~tck; 

    initial begin
        // Initialize signals
        tck = 0;
        reset_n = 0;
        TDI = 0;
        shift_en = 0;
        update_en = 0;
        capture_en = 0;

        // Apply reset (first clock cycle)
        #10; // Hold reset for one cycle
        reset_n = 1;

        // Shift 128 bits into TDI, 1 bit per clock cycle
        shift_en = 1;
        for (i = 0; i < 128; i = i + 1) begin
            TDI = test_data[127 - i]; // Shift MSB first
            #10; // Wait one clock cycle
        end
        shift_en = 0;

        // Update on the 129th cycle
        update_en = 1;
        #10;
        update_en = 0;

        // Capture on the 130th cycle
        capture_en = 1;
        #10;
        capture_en = 0;
        
        shift_en = 1;
        

        // Hold for observation
        #1300;
        shift_en = 0;
        $stop;
    end

endmodule
