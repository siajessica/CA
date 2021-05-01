`define R_Type 2'b10
`define I_Type 2'b00

module Control(
    Op_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o
);

//Ports
input   [6:0]   Op_i;
output  [1:0]   ALUOp_o;
output          ALUSrc_o;
output          RegWrite_o;

reg     [1:0]   ALUOp_o;
reg             ALUSrc_o;
reg             RegWrite_o;

always @(*) begin
    case (Op_i)
        7'b0110011: begin
            ALUOp_o = `R_Type;
            ALUSrc_o = 0;
            RegWrite_o = 1;
        end
        7'b0010011: begin
            ALUOp_o = `I_Type;
            ALUSrc_o = 1;
            RegWrite_o = 1;
        end
    endcase
end

endmodule