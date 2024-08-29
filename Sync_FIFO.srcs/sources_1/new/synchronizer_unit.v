`timescale 1ns / 1ps


module synchronizer_unit #(parameter WIDTH=4)
                        (clk_100mhz,reset,fifo_wr_en,fifo_wr_data,fifo_rd_en,sync_reset,sync_fifo_wr_en,sync_fifo_wr_data,sync_fifo_rd_en,clk_1hz_en);
    input clk_100mhz;
    input reset;
    input fifo_wr_en;
    input [WIDTH-1:0] fifo_wr_data;
    input fifo_rd_en;
    output sync_reset;
    output sync_fifo_wr_en;
    output [WIDTH-1:0] sync_fifo_wr_data;
    output sync_fifo_rd_en;
    output clk_1hz_en;
    
    reg sync_reset;
    reg [WIDTH-1:0] sync_fifo_wr_data;
    reg sync_fifo_wr_en;
    reg sync_fifo_rd_en;
    reg pulse_sync_reg;
    reg [27:0] one_sec;
    reg ce;
    
    assign clk_1hz_en = ce;
    
    always@(posedge clk_100mhz) begin
        if(reset)
            one_sec <= 'd0;
        else begin
            one_sec <= one_sec + 1'b1;
            if(one_sec == 'd999_999_99)begin
                ce <= 1'b1;
                one_sec <= 'd0;
            end        
            else
                ce <= 1'b0;
        end
    end
    
    always@(posedge clk_100mhz)begin
        if(reset)
            pulse_sync_reg <= 1'b1;
        if(one_sec == 'd999_999_99)begin
            sync_reset <= pulse_sync_reg;
            pulse_sync_reg <= reset ? 1'b1 : 1'b0;
        end
        else
            sync_reset <= 1'b0;
    end
    
    always@(posedge clk_100mhz)begin
        if(one_sec == 'd999_999_99)
            sync_fifo_wr_en <= fifo_wr_en;
    end
    
    always@(posedge clk_100mhz)begin
        if(one_sec == 'd999_999_99)
            sync_fifo_rd_en <= fifo_rd_en;
    end
    
    always@(posedge clk_100mhz)begin
        if(one_sec == 'd999_999_99)
            sync_fifo_wr_data <= fifo_wr_data;
    end
endmodule
