`timescale 1ns / 1ps

module stream_upsize #(
    parameter T_DATA_WIDTH = 4,
    T_DATA_RATIO = 2
)(
    input logic clk,
    input logic rst_n,
    input logic [T_DATA_WIDTH-1:0] s_data_i,
    input logic s_last_i,
    input logic s_valid_i,
    output logic s_ready_o,
    output logic [T_DATA_WIDTH-1:0] m_data_o [T_DATA_RATIO-1:0],
    output logic [T_DATA_RATIO-1:0] m_keep_o,
    output logic m_last_o,
    output logic m_valid_o,
    input logic m_ready_i
    );
    localparam LISTENING = 0;
    localparam T_PROCESS = 1;
    localparam T_END = 2;
    logic [1:0] state;

    localparam bufsize = T_DATA_RATIO + 4;
    logic [T_DATA_WIDTH-1:0] data_buf[bufsize-1:0];
    logic [bufsize-1:0] ctr;
    integer ptr = 0;
    
    integer i;
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            s_ready_o <= 1;
            m_keep_o <= 0;
            m_last_o <= 0;
            m_valid_o <= 0;
            state <= LISTENING;
            ctr <= 0;
        end else begin
            case (state)
                LISTENING:
                    begin
                        m_valid_o <= 0;
                        m_keep_o <= 0;
                        m_last_o <= 0;
                        if (s_valid_i) begin
                            data_buf[ptr] <= s_data_i;
                            ptr++;
                            ctr <= ctr + 1;
                        end
                        if (s_last_i) begin
                            state <= T_END;
                            s_ready_o <= 0;
                        end    
                        else if (ptr == T_DATA_RATIO)
                            state <= T_PROCESS;
                    end
                T_PROCESS:
                    begin
                        if (s_valid_i) begin
                            data_buf[0] <= s_data_i;
                            ptr = 1;
                            ctr <= 1;
                        end else begin
                            ctr <= 0;
                            ptr = 0;
                        end
                        m_valid_o <= 1;
                        m_keep_o <= T_DATA_RATIO;
                        for (i = 0; i < T_DATA_RATIO; i++) begin
                            m_data_o[i] <= data_buf[i]; 
                        end 
                        if (s_last_i) begin
                            state <= T_END;
                            s_ready_o <= 0; 
                        end else 
                            state <= LISTENING;    
                    end                        
                T_END:
                    begin
                        m_valid_o <= 1;
                        m_keep_o <= ctr; 
                        s_ready_o <= 1;
                        m_last_o <= 1;
                        state <= LISTENING;
                        for (i = 0; i < ctr; i++) begin
                            m_data_o[i] <= data_buf[i];   
                        end 
                        ctr <= 0;
                        ptr = 0;
                    end
            endcase
        end
    end
    
endmodule
