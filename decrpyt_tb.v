
module dtb ();
reg clk , reset_n_ka , reset_n ,start , en  ;

reg [127:0]test_cyphertext = 128'haa26d13908d945f088a6806ab3eac449 ;
reg [127:0]cyphertext;
reg [127:0]test_key = 128'h0123456789abcdef0123456789abcdef; 
reg [127:0] initial_key;
wire [127:0]plaintext ;


decrypt uut(clk , reset_n_ka, reset_n , start , en , cyphertext , initial_key , plaintext) ;

initial begin
     clk = 0 ;
     forever #5 clk = ~clk ;
end 

initial begin
     reset_n = 0 ;reset_n_ka = 0 ;
     start = 0 ;
     en = 0 ;
     cyphertext = test_cyphertext ;
     initial_key = test_key ;
     #10 
     reset_n_ka = 1 ;en = 1 ;
     #90 
     reset_n = 1 ;start = 1 ;
     #120;
     $stop ;

end


     
endmodule