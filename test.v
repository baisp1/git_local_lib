module test(
    input a
);
//**for_test******************************************************************************
//====时钟复位

    parameter CLK_FREQ = 100    ;//frequence MHz
    parameter LED_FREQ = 1      ;//frequence Hz
    localparam LED_CNT = (CLK_FREQ*1000000/LED_FREQ/2);//LED_FREQ计数的一半，用于信号翻转
    localparam LED_CNT_WIDTH = $clog2(LED_CNT);
    
    reg [LED_CNT_WIDTH-1:0] r_test_led_cnt = 'h0 ;
    reg                     r_led = 1'b0;

IBUFDS #(
   .DIFF_TERM("FALSE"),       // Differential Termination
   
   .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
   .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
) IBUFDS_inst (
   .O(w_sys_clk),  // Buffer output
   .I(i_lc_sys_clk_p),  // Diff_p buffer input (connect directly to top-level port)
   .IB(i_lc_sys_clk_n) // Diff_n buffer input (connect directly to top-level port)
);

always @(posedge w_sys_clk) begin
    if(r_test_led_cnt >= LED_CNT-1) begin
        r_test_led_cnt <= 1'b0;
    end else begin
        r_test_led_cnt <= r_test_led_cnt + 1'b1; 
    end
end

always @(posedge w_sys_clk) begin
    if(r_test_led_cnt == LED_CNT-1) begin
        r_led <= ~r_led;
    end     
end



	
ila_0 your_instance_name (
	.clk(w_sys_clk), // input wire clk


	.probe0(r_test_led_cnt[1]), // input wire [0:0]  probe0  
	.probe1(r_test_led_cnt), // input wire [27:0]  probe1 
	.probe2(r_led) // input wire [0:0]  probe2
);

endmodule
