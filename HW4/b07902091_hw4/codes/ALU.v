module ALU(
    data1_i,  	// 32 bits
    data2_i,  	// 32 bits
    ALUCtrl_i,	// 3 bits
    data_o,   	// 32 bits
    Zero_o 		// 1 bit
    );

// Ports
input 	[31:0] 		data1_i;
input 	[31:0] 		data2_i;
input 	[2:0] 		ALUCtrl_i;
output 	[31:0] 		data_o;
output 				Zero_o;

reg 	[31:0]		data_o;

assign Zero_o = 1'b0;

always @(data1_i or data2_i or ALUCtrl_i) begin
	case(ALUCtrl_i)
		3'b000 	: data_o <= $signed(data1_i) & $signed(data2_i);
		3'b001 	: data_o <= $signed(data1_i) ^ $signed(data2_i);
		3'b010 	: data_o <= $signed(data1_i) << data2_i;
		3'b011 	: data_o <= $signed(data1_i) + $signed(data2_i);
		3'b100 	: data_o <= $signed(data1_i) - $signed(data2_i);
		3'b101 	: data_o <= $signed(data1_i) * $signed(data2_i);
		3'b110 	: data_o <= $signed(data1_i) + $signed(data2_i);
		3'b111 	: data_o <= $signed(data1_i) >>> data2_i[4:0]; 
		default : data_o <= 0;
	endcase
end
endmodule
