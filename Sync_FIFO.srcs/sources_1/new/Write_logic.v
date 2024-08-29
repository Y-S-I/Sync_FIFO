`timescale 1ns / 1ps

module Write_logic #(parameter WIDTH=8,DEPTH=16,ADDR=$clog2(DEPTH))(clk,reset,clk_1hz_en,wc_en,data_count,wc_data,wc_en_pipe,wc_data_pipe,wc_addr,full_flag);
    input clk;
    input reset;
    input clk_1hz_en;
    input wc_en;
    input [ADDR:0] data_count;
    input [WIDTH-1:0] wc_data;
    output reg wc_en_pipe;
    output reg [WIDTH-1:0] wc_data_pipe;
    output [ADDR-1:0] wc_addr;
    output full_flag;
    
    reg [ADDR-1:0] wc_pointer;
    reg wc_full;
    
    always@(*)begin
        wc_full = (data_count==DEPTH) ? 1'b1 : 1'b0;
    end
    
    assign full_flag = wc_full;
    
    always@(posedge clk)begin
        if(clk_1hz_en)begin
            if(reset)
                wc_en_pipe <= 1'b0;
            if(wc_en & !wc_full)
                wc_en_pipe <= 1'b1;
            else
                wc_en_pipe <= 1'b0;
        end
    end
        
    always@(posedge clk)begin
        if(clk_1hz_en)
            wc_data_pipe <= wc_data;
    end
    
    always@(posedge clk)begin
        if(clk_1hz_en) begin
            if(reset)
                wc_pointer <= 'd0;
            else if(wc_en_pipe)
                wc_pointer <= wc_pointer + 1'b1;
        end
    end
    
    assign wc_addr = wc_pointer;
    
endmodule
