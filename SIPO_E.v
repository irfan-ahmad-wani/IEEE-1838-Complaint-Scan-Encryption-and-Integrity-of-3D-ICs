module SIPO (
    input wire clk,                   // Clock signal
    input wire reset_n,               // Active-low reset
    input wire serial_in,             // Serial input bit
    output reg [127:0] data_out       // 128-bit parallel output
);

 
    localparam IDLE    = 2'b00;       // Waiting for the start condition
    localparam STORE   = 2'b01;       // Storing serial input into buffer
    localparam OUTPUT  = 2'b10;       // Outputting 128-bit parallel data

    localparam STORE_CYCLE = 289;     // Cycle count multiple for starting storage
    localparam STORE_DURATION = 128; // Number of cycles to store 128 bits

    // Internal registers
    reg [127:0] buffer;               // Buffer to store 128 bits
    reg [6:0] bit_count;              // Counter for bits in the buffer (0-127)
    reg [15:0] cycle_count;           // Global clock cycle counter
    reg [1:0] state, next_state;      // FSM state and next state

    // Sequential block for state, cycle count, and buffer updates
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            cycle_count <= 16'b0;
            buffer <= 128'b0;
            bit_count <= 7'b0;
            data_out <= 128'b0;
        end else begin
            state <= next_state;
            cycle_count <= cycle_count + 1;

            case (state)
                STORE: begin
                    // Store the serial input into the buffer at the next bit position
                    buffer[127 - bit_count] <= serial_in;
                    bit_count <= bit_count + 1;
                end
                OUTPUT: begin
                    // Output the stored 128-bit data
                    data_out <= buffer;
                end
            endcase

            // Reset bit count after storing 128 bits
            if (bit_count == 127 && state == STORE ) begin
                bit_count <= 7'b0;
            end
        end
    end

    // Combinational block for next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Start storing when cycle_count == STORE_CYCLE (130)
                if (cycle_count == STORE_CYCLE) begin
                    next_state = STORE;
                end else begin
                    next_state = IDLE;
                end
            end
            STORE: begin
                // After storing all 128 bits, move to OUTPUT in the next cycle
                if (bit_count == 127) begin
                    next_state = OUTPUT;
                end else begin
                    next_state = STORE;
                end
            end
            OUTPUT: begin
                // After outputting, return to IDLE to wait for the next cycle
                next_state = IDLE;
                bit_count <= 7'b0;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
