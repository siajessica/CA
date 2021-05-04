`define R_Type  2'b10
`define I_Type  2'b00
`define AND     3'b000
`define XOR     3'b001
`define SLL     3'b010
`define ADD     3'b011
`define SUB     3'b100
`define MUL     3'b101
`define ADDI    3'b110
`define SRAI    3'b111


module ALU_Control(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

//Ports
input   [9:0] funct_i;
input   [1:0] ALUOp_i;
output  [2:0] ALUCtrl_o;
reg     [2:0] ALUCtrl_o;

always @(*) begin
    case(ALUOp_i)
        `R_Type: begin
            case(funct_i)
                10'b0000000111	: ALUCtrl_o <= `AND;
				10'b0000000100	: ALUCtrl_o <= `XOR;
				10'b0000000001	: ALUCtrl_o <= `SLL;
				10'b0000000000	: ALUCtrl_o <= `ADD;
				10'b0100000000	: ALUCtrl_o <= `SUB;
				10'b0000001000 	: ALUCtrl_o <= `MUL;
                default : ALUCtrl_o <= 3'b000;
            endcase
        end

        `I_Type: begin
            case (funct_i[2:0])
                3'b000:	ALUCtrl_o <= `ADDI;
				3'b101: ALUCtrl_o <= `SRAI;
                default : ALUCtrl_o <= 3'b000;
            endcase
        end
    endcase
end

endmodule