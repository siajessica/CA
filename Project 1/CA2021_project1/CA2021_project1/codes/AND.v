module AND(
    data1_in, 	
    data2_in,	
    data_o		
);

// Ports
input   data1_in;
input   data2_in;
output  data_o;

assign data_o = data1_in & data2_in;

endmodule