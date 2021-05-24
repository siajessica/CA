module Equal(
    data1_in, 	
    data2_in,	
    data_o		
);

// Ports
input   [31:0] data1_in;
input   [31:0] data2_in;
output  data_o;

assign  data_o = (data1_in == data2_in)?1'b1:1'b0;

endmodule