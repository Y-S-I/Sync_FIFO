`timescale 1ns / 1ps



module FIFO_Wrapper #(parameter DEPTH=16,WIDTH=8,ADDR=$clog2(DEPTH))
                     (clk,reset,clk_1hz_en,fifo_wr_en,fifo_wr_data,fifo_rd_en,fifo_rd_data,fifo_full,fifo_empty,fifo_data_count);

    input clk;
    input reset;
    input clk_1hz_en;
    input fifo_wr_en;
    input [WIDTH-1:0] fifo_wr_data;
    input fifo_rd_en;
    output [WIDTH-1:0] fifo_rd_data;
    output fifo_full;
    output fifo_empty;
    output reg [ADDR:0] fifo_data_count;
    
    wire [ADDR-1:0] fifo_wr_addr;
    wire [ADDR-1:0] fifo_rd_addr;
    wire fifo_wc_en_pipe;
    wire [WIDTH-1:0] fifo_wr_data_pipe;
    
    // this should not be delayed due to pipeline
            // if wr_en or rd_en is high then w_en_pipe or rd_en_pipe
            // are delayed by one cycle, but between this cycle we 
            // miss condition for full or empty cases
            // is e.g. wr_en is high, then
            // wr_en_pipe and data_counter should change simulataneoulsy only
    wire write_operation = fifo_wr_en & !fifo_full;
    wire read_operation  = fifo_rd_en & !fifo_empty;
    
    
    
    always@(posedge clk)begin
        if(clk_1hz_en)begin
            if(reset)
                fifo_data_count <= 'd0;
            else begin
                if(write_operation & !read_operation)
                    fifo_data_count <= fifo_data_count + 1'b1;
                else if(!write_operation & read_operation)
                    fifo_data_count <= fifo_data_count - 1'b1;
            end
        end
    end

    ram #(DEPTH,WIDTH,ADDR) mem(
    .clk(clk),
    .clk_1hz_en(clk_1hz_en),
    .wr_addr(fifo_wr_addr),
    .wr_data(fifo_wr_data_pipe),
    .w_en(fifo_wc_en_pipe),
    .rd_addr(fifo_rd_addr),
    .rd_data(fifo_rd_data));
    
    
    Write_logic #(WIDTH,DEPTH,ADDR) wr_control(
    .clk(clk),
    .reset(reset),
    .clk_1hz_en(clk_1hz_en),
    .wc_en(fifo_wr_en),
    .data_count(fifo_data_count),
    .wc_data(fifo_wr_data),
    .wc_en_pipe(fifo_wc_en_pipe),
    .wc_data_pipe(fifo_wr_data_pipe),
    .wc_addr(fifo_wr_addr),
    .full_flag(fifo_full));
    
    
    Read_logic #(WIDTH,DEPTH,ADDR) rd_control(
    .clk(clk),
    .reset(reset),
    .clk_1hz_en(clk_1hz_en),
    .rd_en(fifo_rd_en),
    .data_count(fifo_data_count),
    .rd_addr(fifo_rd_addr),
    .empty_flag(fifo_empty));
    
    
endmodule
