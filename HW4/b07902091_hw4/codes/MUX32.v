module MUX32(
    data1_i, 	// 32 bits
    data2_i, 	// 32 bits
    select_i,	// 1 bit
    data_o  	// 32 bits
);

// Ports
input 	[31:0] 		data1_i;
input 	[31:0] 		data2_i;
input 				select_i;
output 	[31:0] 		data_o;

assign data_o = (select_i == 0) ? $signed(data1_i):$signed(data2_i);

endmodule
