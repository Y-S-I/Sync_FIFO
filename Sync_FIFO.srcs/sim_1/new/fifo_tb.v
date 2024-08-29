`timescale 1ns / 1ps


module fifo_tb;
    parameter DEPTH=8,WIDTH=4,ADDR=$clog2(DEPTH);
    reg clk;
    reg clk_1hz;
    reg reset;
    reg fifo_wr_en;
    reg [WIDTH-1:0] fifo_wr_data;
    reg fifo_rd_en;
    wire fifo_full;
    wire fifo_empty;
    wire [3:0] AN;
    wire [6:0] digit_switch;
    
    Top_Module #(DEPTH,WIDTH,ADDR) DUT
                     (clk,reset,fifo_wr_en,fifo_wr_data,fifo_rd_en,fifo_full,fifo_empty,AN,digit_switch);
                                      
    always #5 clk=~clk;
    
    integer c;
    
    initial begin
        forever begin
            clk_1hz=1'b0;
            for(c=0 ; c<'d999_999_99 ; c=c+1)begin
                #10;
            end
            clk_1hz=1'b1;
            #10;
        end
    end
    
    integer i;
    
    initial begin
        #10;
        clk=0;
        reset=1;
        fifo_rd_en <= 0;
        fifo_wr_en <= 0;
        @(posedge clk_1hz);
        @(posedge clk_1hz);
        reset=0;
        @(posedge clk_1hz);
        @(posedge clk_1hz);
        fifo_wr_en <= 1;
        fifo_wr_data <= 'hf;
        
        @(posedge clk_1hz);
        
        fifo_wr_data <= 'he;
        @(posedge clk_1hz);
        
        fifo_wr_data <= 'hd;
        
        @(posedge clk_1hz);
        fifo_wr_data <= 'hc;
        fifo_rd_en <= 0;
        @(posedge clk_1hz);
        fifo_wr_data <= 'hb;
        for(i=0 ; i<11 ; i=i+1)begin
            @(posedge clk_1hz);
            fifo_wr_data <= i;
        end
        @(posedge clk_1hz);
        fifo_wr_en <= 0;
        @(posedge clk_1hz);
        @(posedge clk_1hz);
        fifo_rd_en <= 1;
        for(i=0 ; i<16 ; i=i+1)begin
            @(posedge clk_1hz);
        end
        $finish;
    end                 
endmodule
