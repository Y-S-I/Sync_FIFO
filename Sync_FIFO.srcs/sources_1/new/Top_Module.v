`timescale 1ns / 1ps


module Top_Module
    (clk,reset,fifo_wr_en,fifo_wr_data,fifo_rd_en,fifo_full,fifo_empty,AN,digit_switch);
    parameter DEPTH=8,WIDTH=4,ADDR=$clog2(DEPTH);
    
    input clk;
    input reset;
    input fifo_wr_en;
    input [WIDTH-1:0] fifo_wr_data;
    input fifo_rd_en;
    output fifo_full;
    output fifo_empty;
    output [3:0] AN;
    output [6:0] digit_switch;
    
    wire [ADDR:0] fifo_data_count;
    wire [WIDTH-1:0] fifo_rd_data;
    wire sync_reset;
    wire sync_fifo_wr_en;
    wire [WIDTH-1:0] sync_fifo_wr_data;
    wire sync_fifo_rd_en;
    wire clk_1hz_en;
    
    
    FIFO_Wrapper #(DEPTH,WIDTH,ADDR) FIFO
    (      
        .clk(clk),
        .reset(sync_reset),
        .clk_1hz_en(clk_1hz_en),
        .fifo_wr_en(sync_fifo_wr_en),
        .fifo_wr_data(sync_fifo_wr_data),
        .fifo_rd_en(sync_fifo_rd_en),
        .fifo_rd_data(fifo_rd_data),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty),
        .fifo_data_count(fifo_data_count));
    
    display_fifo #(DEPTH,WIDTH,ADDR) display_unit
    (
        .clk(clk),    
        .reset(reset),    
        .display_data_count(fifo_data_count),
        .display_wr_data(fifo_wr_data),
        .display_rd_data(fifo_rd_data),
        .AN(AN),
        .digit_switch(digit_switch));
        
    synchronizer_unit #(WIDTH) sync_with_1hz      
    (
        .clk_100mhz(clk),
        .reset(reset),
        .fifo_wr_en(fifo_wr_en),
        .fifo_wr_data(fifo_wr_data),
        .fifo_rd_en(fifo_rd_en),
        .sync_reset(sync_reset),
        .sync_fifo_wr_en(sync_fifo_wr_en),
        .sync_fifo_wr_data(sync_fifo_wr_data),
        .sync_fifo_rd_en(sync_fifo_rd_en),
        .clk_1hz_en(clk_1hz_en));
    
endmodule
