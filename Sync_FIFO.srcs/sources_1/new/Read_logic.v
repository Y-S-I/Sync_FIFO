`timescale 1ns / 1ps


module Read_logic#(parameter WIDTH=8,DEPTH=16,ADDR=$clog2(DEPTH))(clk,reset,clk_1hz_en,rd_en,data_count,rd_addr,empty_flag);
    input clk;
    input reset;
    input clk_1hz_en;
    input rd_en;
    input [ADDR:0] data_count;
    output [ADDR-1:0] rd_addr;
    output empty_flag;
    
    
    reg [ADDR-1:0] rd_pointer;
    reg rd_empty;
    
    always@(*)begin
        rd_empty = (data_count==0) ? 1'b1 : 1'b0;
    end
    
    assign empty_flag = rd_empty;
    
    always@(posedge clk) begin
        if(clk_1hz_en)begin
            if(reset)
                rd_pointer <= 'd0;
            else if(!rd_empty & rd_en)
                rd_pointer <= rd_pointer + 1'b1;
        end
    end
    
    assign rd_addr = rd_pointer;
    
endmodule