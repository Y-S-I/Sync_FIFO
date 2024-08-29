`timescale 1ns / 1ps


module ram_tb;
    parameter WIDTH=8,DEPTH=16,ADDR=$clog2(DEPTH);
    reg clk;
    reg [ADDR-1:0] wr_addr;
    reg [WIDTH-1:0] wr_data;
    reg w_en;
    reg [ADDR-1:0] rd_addr;
    wire [WIDTH-1:0] rd_data;
    
    ram #(DEPTH,WIDTH,ADDR) DUT(clk,wr_addr,wr_data,w_en,rd_addr,rd_data);
    
    always #5 clk=~clk;
    
    integer i;
    initial begin
        clk=0;
        for(i=0; i<16 ; i=i+1)begin
            rd_addr <= i;
            @(posedge clk);
        end
        w_en<=1;
        @(posedge clk);
        for(i=0; i<16 ; i=i+1)begin
            wr_addr <= i;
            wr_data <= 16-i;
            @(posedge clk);
            @(posedge clk);
        end
    end
endmodule
