`timescale 1ns / 1ps

module tb_stream_upsize;
    parameter T_DATA_WIDTH = 4;
    parameter T_DATA_RATIO = 2;

    logic clk;
    logic rst_n;
    logic [T_DATA_WIDTH-1:0] s_data_i;
    logic s_last_i;
    logic s_valid_i;
    logic s_ready_o;
    logic [T_DATA_WIDTH-1:0] m_data_o[T_DATA_RATIO-1:0];
    logic [T_DATA_RATIO-1:0] m_keep_o;
    logic m_last_o;
    logic m_valid_o;
    logic m_ready_i;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    stream_upsize #(
        .T_DATA_WIDTH(T_DATA_WIDTH),
        .T_DATA_RATIO(T_DATA_RATIO)
    ) inst (
        .clk(clk),
        .rst_n(rst_n),
        .s_data_i(s_data_i),
        .s_last_i(s_last_i),
        .s_valid_i(s_valid_i),
        .s_ready_o(s_ready_o),
        .m_data_o(m_data_o),
        .m_keep_o(m_keep_o),
        .m_last_o(m_last_o),
        .m_valid_o(m_valid_o),
        .m_ready_i(m_ready_i)
    );

    initial begin
        rst_n = 0;
        s_data_i = 0;
        s_last_i = 0;
        s_valid_i = 0;
        m_ready_i = 1;

        #50;
        rst_n = 1;
        @(posedge clk);
        
        /*s_valid_i = 1;
        s_data_i = 4'h0; 
        @(posedge clk);
        s_data_i = 4'h1; 
        @(posedge clk);
        s_data_i = 4'h2;
        @(posedge clk);
        s_data_i = 4'h3;   
        @(posedge clk);
        s_data_i = 4'h4;  
        s_last_i = 1;        
        @(posedge clk);
        s_data_i = 4'hA;
        s_last_i = 0;
        @(posedge clk);
        @(posedge clk);
        s_data_i = 4'hB;
        s_last_i = 1;    
        @(posedge clk);
        s_valid_i = 0;
        s_last_i = 0;*/
        
        s_valid_i = 1;
        s_data_i = 4'h0; 
        @(posedge clk);
        s_data_i = 4'h1; 
        @(posedge clk);
        s_data_i = 4'h2;  
        s_last_i = 1;     
        @(posedge clk);
        s_data_i = 4'hA;
        s_last_i = 0;
        @(posedge clk);
        @(posedge clk);
        s_data_i = 4'hB;
        s_last_i = 1;    
        @(posedge clk);
        s_valid_i = 0;
        s_last_i = 0;

        #1000;
        $stop;
    end

endmodule

