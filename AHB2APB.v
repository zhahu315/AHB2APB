`timescale 1ns / 1ps
`include "./slave.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/18 12:46:34
// Design Name: 
// Module Name: AHB2APB
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


module AHB2APB(
    HRST,
    HCLK,
    HADDR,
    Control,
    HWDATA,
    HRDATA
    );
    input HRST,HCLK,Control;
    input [31:0]HADDR;
    input [31:0]HWDATA;
    output reg [31:0]HRDATA;

    wire HRDATA0,HRDATA1,HRDATA2,HRDATA3;
    reg HREADY=1;
    wire PENABLE0,PENABLE1,PENABLE2,PENABLE3;
    reg PSEL0,PSEL1,PSEL2,PSEL3;
    wire PSETUP0,PSETUP1,PSETUP2,PSETUP3;

    reg PCLK = 1'b0;

    //产生二分频时钟
    always @(posedge HCLK)begin
        PCLK <= ~PCLK;
            if(HREADY)
            begin
            case(HADDR[9:8])
                2'b00:begin
                    PSEL0=1;PSEL1=0;PSEL2=0;PSEL3=0;
                end 
                2'b01:begin
                    PSEL0=0;PSEL1=1;PSEL2=0;PSEL3=0;
                end
                2'b10:begin
                    PSEL0=0;PSEL1=0;PSEL2=1;PSEL3=0;
                end 
                2'b11:begin
                    PSEL0=0;PSEL1=0;PSEL2=0;PSEL3=1;
                end 
                default:begin
                    PSEL0=0;PSEL1=0;PSEL2=0;PSEL3=0;
                end 
            endcase
        end
        else begin
        end
    end

    //与从设备通信
    slave slave0(.PCLK(PCLK),.PRST(HRST),.PSELx(PSEL0),.PWRITE(Control),.PADDR(HADDR),.PWDATA(HWDATA),.PRDATA(HRDATA0),.PENABLE(PENABLE0),.SETUP(PSETUP0));
    slave slave1(.PCLK(PCLK),.PRST(HRST),.PSELx(PSEL1),.PWRITE(Control),.PADDR(HADDR),.PWDATA(HWDATA),.PRDATA(HRDATA1),.PENABLE(PENABLE1),.SETUP(PSETUP1));
    slave slave2(.PCLK(PCLK),.PRST(HRST),.PSELx(PSEL2),.PWRITE(Control),.PADDR(HADDR),.PWDATA(HWDATA),.PRDATA(HRDATA2),.PENABLE(PENABLE2),.SETUP(PSETUP2));
    slave slave3(.PCLK(PCLK),.PRST(HRST),.PSELx(PSEL3),.PWRITE(Control),.PADDR(HADDR),.PWDATA(HWDATA),.PRDATA(HRDATA3),.PENABLE(PENABLE3),.SETUP(PSETUP3));

    //hready信号控制

    always @(PSETUP0 or PSETUP1 or PSETUP2 or PSETUP3 or PENABLE0 or PENABLE1 or PENABLE2 or PENABLE3)begin
        if (PSETUP0|PSETUP1|PSETUP2|PSETUP3|PENABLE0|PENABLE1|PENABLE2|PENABLE3) begin
            HREADY = 0;
        end
        else HREADY = 1;
    end

    always @(*)begin
        if (PSEL0)
        HRDATA = HRDATA0;
        else if (PSEL1) HRDATA = HRDATA1;
        else if (PSEL2) HRDATA = HRDATA2;
        else if (PSEL3) HRDATA = HRDATA3;
        else HRDATA = 32'bz;
    end
endmodule
