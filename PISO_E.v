module PISO (
    input wire clk,                // Clock signal
    input wire reset_n,            // Active-low reset
    input wire [127:0] data_in,    // 128-bit parallel input
    output reg serial_out          // Serial output
);

    // Parameters
    localparam IDLE       = 2'b00; // Waiting state
    localparam STORE      = 2'b01; // Store parallel data
    localparam SERIALIZE  = 2'b10; // Serializing data

    localparam TARGET_CLOCK = 16'd450; // Clock cycle at which to store the input

    // Internal Registers
    reg [127:0] buffer;      // Buffer to hold 128-bit data
    reg [6:0] bit_counter;   // Counts bits for serialization (0-127)
    reg [15:0] clock_counter; // Global clock cycle counter
    reg [1:0] state, next_state; // FSM states

    // Sequential block for state transition and operations
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            clock_counter <= 16'b0;
            buffer <= 128'b0;
            bit_counter <= 7'b0;
            serial_out <= 1'b0;
        end else begin
            state <= next_state;
            
            // Global clock cycle counter
            clock_counter <= clock_counter + 1;

            case (state)
                STORE: begin
                    buffer <= data_in; // Store 128-bit input into buffer
                    bit_counter <= 0;  // Reset bit counter
                end
                SERIALIZE: begin
                    serial_out <= buffer[127 - bit_counter]; // Shift out MSB first
                    bit_counter <= bit_counter + 1;
//                    if(bit_counter>127)
//                    begin
//                    serial_out= 1'b0;
//                    end
                end
                IDLE : begin
                    buffer <= 128'b0;
                    serial_out <= 128'b0;
                end
            endcase

            // Reset bit counter after serialization
            if (bit_counter == 127 && state == SERIALIZE) begin
                bit_counter <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (clock_counter == TARGET_CLOCK) 
                    next_state = STORE;  // Move to STORE when target clock is reached
                else 
                    next_state = IDLE;
            end
            STORE: begin
                next_state = SERIALIZE; // Move to SERIALIZE in next cycle
            end
            SERIALIZE: begin
                if (bit_counter == 127) 
                    next_state = IDLE;  // Return to IDLE after serialization completes
                else 
                    next_state = SERIALIZE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
