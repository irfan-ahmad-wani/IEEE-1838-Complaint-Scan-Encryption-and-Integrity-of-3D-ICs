`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.02.2025 15:05:33
// Design Name: 
// Module Name: TAP_En_SC_De
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


module TAP_En_SC_De(
    input wire tck,
    input wire trst_n,
    input wire tms,
    input wire reset_n_ka,start,en,
    
    input wire TDI,
    input wire [127:0] initial_key,
    
    output wire TDO,

    output wire capture_en,
    output wire shift_en,
    output wire update_en
    );
    
    
tap_controller TC (
    .tck(tck),
    .trst_n(trst_n),
    .tms(tms),
    .Capture_En(capture_en),
    .Shift_En(shift_en),
    .Update_En(update_en)
);


Decrypt_Scan_chain_Encrypt T_E_SC_D(
    .tck(tck),
    .reset_n(trst_n),
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
endmodule
