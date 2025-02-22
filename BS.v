module BS ( // 
     input wire  [127:0] in ,
     output wire  [127:0] out 
);

wire [127:0]bs_out ;

byteSub s0(.in(in[31 -: 32]) , .out(out[31 -: 32])) ; 
byteSub s1(.in(in[63 -: 32]) , .out(out[63 -: 32])) ; 
byteSub s2(.in(in[95 -: 32]) , .out(out[95 -: 32])) ; 
byteSub s3(.in(in[127 -: 32]) , .out(out[127 -: 32])) ; 
     
endmodule