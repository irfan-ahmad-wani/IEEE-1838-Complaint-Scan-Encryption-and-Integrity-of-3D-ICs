`timescale 1ns / 1ps

module keyExpan_tb;

    // Testbench signals
    reg clk;
    reg en;
    reg reset_n;
    reg [3:0] round;
    reg [127:0] initial_key;
    wire [127:0] round_key;

    // Instantiate the keyExpan module
    keyExpan dut (
        .clk(clk),
        .en(en),
        .round(round),
        .initial_key(initial_key),
        .reset_n(reset_n),
        .round_key(round_key)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Reset task
    task reset;
        begin
            reset_n = 0;
            #10;
            reset_n = 1;
        end
    endtask

    // Main test process
    initial begin
        $display("Starting Key Expansion Testbench");

        // Initialize signals
        en = 0;
        round = 0;
        initial_key = 128'h0; // Example AES key

        // Apply reset
        reset();

        // Enable the module
        en = 1;

        // Test each round
        for (round = 0; round <= 10; round = round + 1) begin
            @(posedge clk);
            #1; // Wait for computation
            $display("Round %d Key: %h", round, round_key);
        end

        // Disable the module
        en = 0;

        $display("Key Expansion Testbench Completed");
        $stop;
    end

endmodule
