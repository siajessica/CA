module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;


// Memory
reg      [24:0]    tag [0:15][0:1];    
reg      [255:0]   data[0:15][0:1];
reg      [15:0]    LRU;

integer            i, j;
integer            idx;


// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
        LRU <= 16'b0; //initialize LRU
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here
        if (tag[addr_i][0][22:0] == tag_i[22:0]) begin
            data[addr_i][0] <= data_i;
            tag[addr_i][0] <= tag_i;
            tag[addr_i][0][23] <= 1'b1;
            LRU[addr_i] <= 1'b1;
        end
        else if (tag[addr_i][1][22:0] == tag_i[22:0]) begin
            data[addr_i][1] <= data_i;
            tag[addr_i][1] <= tag_i;
            tag[addr_i][1][23] <= 1'b1;
            LRU[addr_i] <= 1'b0;
        end
        else begin
            data[addr_i][LRU[addr_i]] <= data_i;
            tag[addr_i][LRU[addr_i]] <= tag_i;
            LRU[addr_i] <= ~LRU[addr_i];
        end  
    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?
wire equal_1, equal_2;
wire valid_1, valid_2;
wire res_1, res_2;
assign equal_1 = (tag_i[22:0] == tag[addr_i][0][22:0])?1'b1:1'b0;
assign equal_2 = (tag_i[22:0] == tag[addr_i][1][22:0])?1'b1:1'b0;
assign res_1 = equal_1 & tag[addr_i][0][24];
assign res_2 = equal_2 & tag[addr_i][1][24];
assign hit_o = res_1 | res_2;
assign data_o = (hit_o) ? ((res_1) ? data[addr_i][0] : data[addr_i][1]) : data[addr_i][LRU[addr_i]];
assign tag_o = (hit_o) ? ((res_1) ? tag[addr_i][0] : tag[addr_i][1]) : tag[addr_i][LRU[addr_i]];

always @(posedge clk_i or posedge rst_i) begin
    if (hit_o) begin
        if (res_1) begin
            LRU[addr_i] <= 1'b1;
        end
        else begin
            LRU[addr_i] <= 1'b0;
        end
    end
end

endmodule
