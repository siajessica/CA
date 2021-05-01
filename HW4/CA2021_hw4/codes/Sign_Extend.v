module Sign_Extend(
    data_i,
    data_0
);

//Ports
input [31:0] data_i;
output [31:0] data_o;

assign data_o = $signed({{20{data_i[11]}},data_i[11:0]});

endmodule