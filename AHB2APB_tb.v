`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/19 10:56:08
// Design Name: 
// Module Name: AHB2APB_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AHB2APB_tb(
);
    reg HRST=1;
    reg HCLK,Control;
    reg [31:0] HADDR,HWDATA;
    wire [31:0] HRDATA;


    AHB2APB DUT(
        HRST,
        HCLK,
        HADDR,
        Control,
        HWDATA,
        HRDATA
    );

    always
        #20 HCLK=~HCLK;

    initial begin
        HCLK = 0;
        #10 HRST = 0;
        #40 Control = 1;
        //slave0的第四个寄存器存入aaaaaaaa
        #10 HADDR = 32'b0000_0000_0000_0000_0000_0000_00001100;
        #40 HWDATA = 32'haaaaaaaa;
        //slave1第四个寄存器存入bbbbbbbb
        #160 HADDR = 32'b0000_0000_0000_0000_0000_0001_00001100;
        #40 HWDATA = 32'hbbbbbbbb;
        //slave2第四个寄存器存入cccccccc
        #160 HADDR = 32'b0000_0000_0000_0000_0000_0010_00001100;
        #40 HWDATA = 32'hcccccccc;
        //slave3第四个寄存器存入dddddddd
        #160 HADDR = 32'b0000_0000_0000_0000_0000_0011_00001100;
        #40 HWDATA = 32'hdddddddd;
        #240 HADDR = 32'bz;
        #80 Control = 0;
        //依次再按顺序读出存入的4个值
        #80 HADDR = 32'b0000_0000_0000_0000_0000_0000_00001100;
        #240 HADDR = 32'b0000_0000_0000_0000_0000_0001_00001100;
        #240 HADDR = 32'b0000_0000_0000_0000_0000_0010_00001100;
        #240 HADDR = 32'b0000_0000_0000_0000_0000_0011_00001100;
        #240 HADDR = 32'bz;
    end

endmodule