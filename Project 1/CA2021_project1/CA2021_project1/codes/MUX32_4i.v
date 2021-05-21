module MUX32_4i(
	Forward_in,
	EXRS_Data_in,
	MEM_ALU_Result_in,
	WB_WriteData_in,
	MUX_Res_o
);

//Ports
input   [1:0]   Forward_in;
input   [31:0]  EXRS_Data_in;
input   [31:0]  MEM_ALU_Result_in;
input   [31:0]  WB_WriteData_in;
output  [31:0]  MUX_Res_o;

reg     [31:0]  MUX_Res;

assign MUX_Res_o = MUX_Res;

always @(*) begin
	case (Forward_in)
        2'b00:	begin
            MUX_Res = EXRS_Data_in;
        end

		2'b01: begin
            MUX_Res = WB_WriteData_in;
        end

        2'b10: begin
            MUX_Res = MEM_ALU_Result_in;
        end

        default: begin
            MUX_Res = EXRS_Data_in;
        end
    endcase
end

endmodule