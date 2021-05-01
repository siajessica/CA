module ALU_Control(
    funct_i,	// 10 bits [30:25,14:12]
    ALUOp_i,	// 2 bits
    ALUCtrl_o 	// 3 bits
);

// Ports
input 	[9:0] 		funct_i;
input 	[1:0] 		ALUOp_i;
output 	[2:0] 		ALUCtrl_o;

reg 	[2:0] 		ALUCtrl_o;

always @(*) begin
	// R-Format -> Arithmetic 
	if (ALUOp_i == 2'b10) begin
		case(funct_i)
			10'b0000000111	: ALUCtrl_o <= 3'b000;
			10'b0000000100	: ALUCtrl_o <= 3'b001;
			10'b0000000001	: ALUCtrl_o <= 3'b010;
			10'b0000000000	: ALUCtrl_o <= 3'b011;
			10'b0100000000	: ALUCtrl_o <= 3'b100;
			10'b0000001000 	: ALUCtrl_o <= 3'b101;
			default : ALUCtrl_o <= 3'b000;
		endcase
	end 

	// I-Format -> Load & Immediate Arithmetic
	else if (ALUOp_i == 2'b00) begin
		if (funct_i[2:0] == 3'b000) begin 			
			ALUCtrl_o <= 3'b110;
		end 

		else if (funct_i[2:0] == 3'b101) begin 	
			ALUCtrl_o <= 3'b111;
		end
	end
	
end

endmodule
