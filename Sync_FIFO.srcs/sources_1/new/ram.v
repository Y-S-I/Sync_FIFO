`timescale 1ns / 1ps


module ram #(parameter DEPTH=16,WIDTH=8,ADDR=$clog2(DEPTH))(clk,clk_1hz_en,wr_addr,wr_data,w_en,rd_addr,rd_data);
    input clk;
    input clk_1hz_en;
    input [ADDR-1:0] wr_addr;
    input [WIDTH-1:0] wr_data;
    input w_en;
    input [ADDR-1:0] rd_addr;
    output reg [WIDTH-1:0] rd_data;
    
    reg [WIDTH-1:0] memory [DEPTH-1 : 0];
    
//    for initial testing of ram during simulation    
//    initial begin
//        $readmemh("mem_init.mem",memory);
//    end
    
    always@(posedge clk) begin
        if(clk_1hz_en)begin
            if(w_en)
                memory[wr_addr] <= wr_data;
        end
    end
    
    always@(posedge clk) begin
        if(clk_1hz_en)
            rd_data <= memory[rd_addr];
    end
    
endmodule
