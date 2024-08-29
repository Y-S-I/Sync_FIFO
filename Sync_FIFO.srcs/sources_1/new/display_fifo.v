`timescale 1ns / 1ps



module display_fifo #(parameter DEPTH=8,WIDTH=4,ADDR=$clog2(DEPTH))
    (clk,reset,display_data_count,display_wr_data,display_rd_data,AN,digit_switch);
    input clk;   
    input reset;   
    input [ADDR:0] display_data_count;
    input [WIDTH-1:0] display_wr_data;
    input [WIDTH-1:0] display_rd_data;
    output reg [3:0] AN;
    output reg [6:0] digit_switch;
    
    reg [6:0] dig0;
    reg [6:0] dig1;
    reg [6:0] dig2;
    reg [6:0] dig3;
    
    reg enable=1'b0;
    reg[16:0] one_milli='d0;
    
    wire [6:0] hex_count_data;
    wire [6:0] hex_rd_data;
    wire [6:0] hex_wr_data;
    
    bcd_to_hex count_convert   (display_data_count,hex_count_data);
    bcd_to_hex rd_data_convert (display_rd_data,hex_rd_data);
    bcd_to_hex wr_data_convert (display_wr_data,hex_wr_data);
    
    always@(posedge clk)begin
        if(enable)
            enable <= 1'b0;
        else
            one_milli <= one_milli + 1'b1;
        if(one_milli + 1'b1 == 'd100000)begin
            enable <= 1'b1;
            one_milli <= 'd0;
        end
    end
    
    always@(posedge clk)begin
        if(reset)begin
            AN <= 4'b0111;
            dig0 <= 7'b1000000;
            dig1 <= 7'b1000000;
            dig2 <= 7'b1000000;
            dig3 <= 7'b1000000;
        end
        else if(enable)begin
            AN <= {AN[0],AN[3:1]};
            dig2 <= 7'b0111111;
            dig0 <= hex_wr_data; // write_data
            dig1 <= hex_rd_data; // read_data
            dig3 <= hex_count_data; // count
        end
    end
    
    always@(*)begin
        case(AN)
            4'b0111: digit_switch = dig0;
            4'b1011: digit_switch = dig1;
            4'b1101: digit_switch = dig2;
            4'b1110: digit_switch = dig3;
            default: digit_switch = 7'b0001110;
        endcase
    end
endmodule
