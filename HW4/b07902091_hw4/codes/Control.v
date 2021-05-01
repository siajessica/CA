module Control(
	Op_i,		// 7 bits [6:0]
	ALUOp_o,	// 2 bits
	ALUSrc_o,	// 1 bits
	RegWrite_o 	// 1 bits
);

// Ports
input 	[6:0]		Op_i;		
output 	[1:0] 		ALUOp_o;
output 				ALUSrc_o;
output 				RegWrite_o;

reg 	[1:0]		ALUOp_o;
reg 				ALUSrc_o;
reg 				RegWrite_o;

always @(*) begin
	ALUOp_o <= (Op_i == 7'b0110011)? 2'b10:2'b00;
	ALUSrc_o <= (Op_i == 7'b0110011)? 0:1;
	RegWrite_o <= 1;
end

endmodule
