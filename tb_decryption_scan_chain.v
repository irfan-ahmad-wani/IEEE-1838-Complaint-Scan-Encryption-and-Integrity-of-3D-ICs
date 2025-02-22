`timescale 1ns / 1ps

module tb_decryption_scan_chain;

    reg tck, reset_n, reset_n_ka, start, en;
    reg TDI;
    reg shift_en, update_en, capture_en;
    reg [127:0] initial_key;
    wire TDO;
    integer i;
    
    reg [127:0] test_serial_in = 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
    reg [31:0] cycle_count; // Counter to track clock cycles after reset_n is high

    
Decrypt_Scan_chain  uut (
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
        .TDO(TDO)
);

    // Generate clock with a period of 10ns (100MHz)
    always #5 tck = ~tck;

    // Counter to track clock cycles after reset_n is high
    always @(posedge tck) begin
        if (reset_n) begin
            cycle_count <= cycle_count + 1; // Increment cycle_count when reset_n is high
        end else begin
            cycle_count <= 0; // Reset cycle_count when reset_n is low
        end
    end

    initial begin
        // Initialize signals
        tck = 0;
        reset_n = 0;
        reset_n_ka = 0;
        start = 0;
        en = 0;
        TDI = 0;
        shift_en = 0;
        update_en = 0;
        capture_en = 0;
        initial_key = 128'h0123456789abcdef0123456789abcdef;
        cycle_count = 0; // Initialize cycle_count to 0

        // Apply reset sequence
        #10;
        reset_n_ka = 1;
        en = 1;
        start = 1; 
        #110;
        reset_n = 1; // Enable reset_n high
        #60;   

        // Shift in test data
        for (i = 127; i >= 0; i = i - 1) begin
            TDI = test_serial_in[i];
            #10; // Assuming one bit per clock cycle
        end
        #230;
        shift_en = 1;
        update_en = 0;
        capture_en = 0;
        #1290;

        update_en = 0;
        update_en = 1;
        shift_en = 0;
        #10;

        capture_en = 1;
        update_en = 0;
        shift_en = 0;
        #10;

        shift_en = 1;
        update_en = 0;
        capture_en = 0;
        #15000;

      

        // Display the total number of clock cycles after reset_n is high
        $display("Total clock cycles after reset_n is high: %0d", cycle_count);

        $stop;
    end
endmodule