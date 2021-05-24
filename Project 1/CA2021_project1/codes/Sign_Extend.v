`define R       7'b0110011
`define I_Imm   7'b0010011
`define I_lw    7'b0000011
`define S       7'b0100011
`define SB      7'b1100011

module Sign_Extend(
    data_i,
    data_o
);

//Ports
input   [31:0] data_i;
output  [31:0] data_o;
reg     [31:0] data_o;

always @(*) begin
    case(data_i[6:0])
        `R: begin
            data_o[31:0]  = 32'b0;
        end

        `I_Imm: begin
            data_o[31:0] = {{20{data_i[31]}},data_i[31:20]};
        end

        `I_lw: begin
            data_o[31:0] = {{20{data_i[31]}},data_i[31:20]};
        end

        `S: begin
            data_o[31:12] = {20{data_i[31]}};
			data_o[11:5] = data_i[31:25];
			data_o[4:0] = data_i[11:7];
        end

        `SB: begin
            data_o[31:11] = {21{data_i[31]}};
			data_o[10] = data_i[7];
			data_o[9:4] = data_i[30:25];
			data_o[3:0] = data_i[11:8];
        end
        default: data_o[31:0]  = 32'b0;
    endcase
end

endmodule
