module tap_controller (
    input wire tck,
    input wire trst_n,
    input wire tms,
    output wire Capture_En,  // Keep as wire
    output wire Shift_En,    // Keep as wire
    output wire Update_En    // Keep as wire
);

    reg capture_en;
    reg shift_en;
    reg update_en;
    
    parameter test_logic_reset = 4'b0000;
    parameter run_test_idle    = 4'b0001;
    parameter select_dr        = 4'b0010;
    parameter capture_dr       = 4'b0011;
    parameter shift_dr         = 4'b0100;
    parameter exit1_dr         = 4'b0101;
    parameter pause_dr         = 4'b0110;
    parameter exit2_dr         = 4'b0111;
    parameter update_dr        = 4'b1000;

    reg [3:0] current_state, next_state;

    
    assign Capture_En = capture_en;
    assign Shift_En   = shift_en;
    assign Update_En  = update_en;

    always @(posedge tck or negedge trst_n) begin
        if (!trst_n)
            current_state <= test_logic_reset;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;

        case (current_state)
            test_logic_reset: next_state = tms ? test_logic_reset : run_test_idle;
            run_test_idle:    next_state = tms ? select_dr : run_test_idle;
            select_dr:        next_state = tms ? test_logic_reset : capture_dr;
            capture_dr:       next_state = tms ? exit1_dr : shift_dr;
            shift_dr:         next_state = tms ? exit1_dr : shift_dr;
            exit1_dr:         next_state = tms ? update_dr : pause_dr;
            pause_dr:         next_state = tms ? exit2_dr : pause_dr;
            exit2_dr:         next_state = tms ? update_dr : shift_dr;
            update_dr:        next_state = tms ? select_dr : run_test_idle;
            default:          next_state = test_logic_reset;
        endcase
    end

    always @(current_state) begin
        capture_en = 1'b0;
        shift_en = 1'b0;
        update_en = 1'b0;

        case (current_state)
            capture_dr: capture_en = 1'b1;
            shift_dr:   shift_en = 1'b1;
            update_dr:  update_en = 1'b1;
        endcase
    end

endmodule
