
module encrypt_tb ( );

reg clk;
reg start , en;
reg reset_n;
reg [127:0] plaintext;
reg [127:0] initial_key;
wire [127:0] cyphertext;

encrypt uut(clk , reset_n, start , en , plaintext , initial_key , cyphertext ) ;

reg [127:0] test_plaintext = 128'h9a5a13e28d1cba92bbbbfb4aaa88095f; // Example plaintext
reg [127:0] test_key = 128'h0123456789abcdef0123456789abcdef;    // Example AES key

initial begin
     clk = 0 ;
     forever #5 clk = ~clk ;
end

initial begin
     reset_n = 0;
     en = 0 ;
     start = 0;
     
     plaintext = test_plaintext;
     initial_key = test_key;
     #12 en = 1 ;
     #10 reset_n = 1 ;start = 1 ;
     #115 
     $stop ;

end


     
endmodule