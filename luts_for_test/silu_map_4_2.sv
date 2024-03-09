module silu_lut(input logic [3:0] data_in_0, output logic [3:0] data_out_0);
    always_comb begin
        case(data_in_0)
            4'b0000: data_out_0 = 4'b0000;
            4'b0001: data_out_0 = 4'b0001;
            4'b0010: data_out_0 = 4'b0001;
            4'b0011: data_out_0 = 4'b0010;
            4'b0100: data_out_0 = 4'b0011;
            4'b0101: data_out_0 = 4'b0100;
            4'b0110: data_out_0 = 4'b0101;
            4'b0111: data_out_0 = 4'b0110;
            4'b1000: data_out_0 = 4'b1111;
            4'b1001: data_out_0 = 4'b1111;
            4'b1010: data_out_0 = 4'b1111;
            4'b1011: data_out_0 = 4'b1111;
            4'b1100: data_out_0 = 4'b1111;
            4'b1101: data_out_0 = 4'b1111;
            4'b1110: data_out_0 = 4'b1111;
            4'b1111: data_out_0 = 4'b0000;
            default: data_out_0 = 4'b0;
        endcase
    end
endmodule
