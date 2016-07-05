/**
 * $Id: red_pitaya_hk.v 961 2014-01-21 11:40:39Z matej.oblak $
 *
 * @brief Red Pitaya house keeping.
 *
 * @Author Matej Oblak
 *
 * (c) Red Pitaya  http://www.redpitaya.com
 *
 * This part of code is written in Verilog hardware description language (HDL).
 * Please visit http://en.wikipedia.org/wiki/Verilog
 * for more details on the language used herein.
 */



/**
 * GENERAL DESCRIPTION:
 *
 * House keeping module takes care of system identification.
 *
 *
 * This module takes care of system identification via DNA readout at startup and
 * ID register which user can define at compile time.
 * 
 
 
 * What is DNA? What is system identification? 
 * What is ID register? 
 *
 
 * Beside that it is currently also used to test expansion connector and for
 * driving LEDs.
 * 
 
 * What is expansion connector? 
 */





module red_pitaya_hk
/* Module definition is pretty standard in beginning verilog code. Defines a "new circuit." */

(
   // LED
   output     [  8-1: 0] led_o           ,  //!< LED output
   // Defines an output port of the circuit as an "LED" with a bus width of 8. i. e. 8 LEDs
   
   
   // Expansion connector -- an expansion connector allows for more ports to be created and allows for different devices specified by
   // the user to be attached
   input      [  8-1: 0] exp_p_dat_i     ,  //!< exp. con. input data --> Define an input register with a bus width of 8. 'exp' for
   //expansion connector, and 'i' for input. Don't know what the 'p' stands for. 
   
   output reg [  8-1: 0] exp_p_dat_o     ,  //!< exp. con. output data --> Define the corresponding output register with same width
   
   output reg [  8-1: 0] exp_p_dir_o     ,  //!< exp. con. 1-output enable --> What is the difference between the 'dir' and 'dat'
   // registers? I think that 'dat' stands for data....
   
   input      [  8-1: 0] exp_n_dat_i     ,  //!< Another input register
   output reg [  8-1: 0] exp_n_dat_o     ,  //!< Another output register
   output reg [  8-1: 0] exp_n_dir_o     ,  //!< Another output register

   // XADC -- analog to digital converters. I think this is storing information about the analog to digital converters? 
   input      [ 12-1: 0] adc_v_i         ,  //!< measured temperatures and voltage supplies Voltage of ADC? 
   input      [ 12-1: 0] adc_temp_i      , // Temperature of ADC?
   input      [ 12-1: 0] adc_pint_i      , // not really sure what the rest of these register definitions are referring to with regard
   // to ADCs... They all seem to be input registers though. 
   input      [ 12-1: 0] adc_paux_i      , 
   input      [ 12-1: 0] adc_bram_i      , 
   input      [ 12-1: 0] adc_int_i       ,
   input      [ 12-1: 0] adc_aux_i       ,
   input      [ 12-1: 0] adc_ddr_i       ,

   // System bus -- Not totally sure but I think buses are like highways connecting different serial communications. Generally I 
   // think this refers to communication with everything on the chip. I imagine that
   // the registers for the bus components defined below may possibly refer to variables that are constant throughout the chip
   
   input                 sys_clk_i       ,  //!< bus clock --> Define a register to store a clock signal
   
   input                 sys_rstn_i      ,  //!< bus reset - active low --> Define a register to store a reset signal. Not totally 
   //sure what this would mean, but I would guess that if the reset signal changes it produces some sort of change in the system. i. e.
   // there is a conditional statement based on the reset signal...
   
   input      [ 32-1: 0] sys_addr_i      ,  //!< bus address --> Not really sure about the bus address, but I think that this is a 
   //register storing the value of the name of the memory location where some value is to be stored later on
   
   input      [ 32-1: 0] sys_wdata_i     ,  //!< bus write data --> register that stores the data that is going to be written to memory
   
   input      [  4-1: 0] sys_sel_i       ,  //!< bus write byte select --> register that is used to index which byte is written to 
   // memory
   
   input                 sys_wen_i       ,  //!< bus write enable --> you can only write to memory based on whether the value of this 
   // register is a 0 or 1. There is probably another conditional statement based on this register value. It can be viewed as
   // controlling a switch
   
   input                 sys_ren_i       ,  //!< bus read enable --> based on the value of this one bit register, you can determine 
   // whether you are allowed to read the data from memory
   
   output reg [ 32-1: 0] sys_rdata_o     ,  //!< bus read data --> Register storing the data that is read from memory. 
   
   output reg            sys_err_o       ,  //!< bus error indicator --> based on the value of this register we can tell whether some 
   // error occurred in the bus
   output reg            sys_ack_o          //!< bus acknowledge signal --> Not really sure what this register does. 

);





//---------------------------------------------------------------------------------
//
reg [8-1:0] led_reg;  --> Define the registers corresponding to the LEDs

reg [25:0] led_counter; --> Define some LED counter variable that is 26 bits long. 

always @(posedge sys_clk_i) begin --> The clock signal is an oscillating square wave. At alternating ticks in time the clock releases 
// either a 0 or a 1. This statement basically says, at each rising edge of the square wave, "do something."

   if (!sys_rstn_i) begin led_counter <= 26'h0; // 'if sys_rstn_i' is saying 'if sys_rstn_i==1.' 'if (!sys_rstn_i)' is saying 
   // 'if sys_rstn_i does not equal 1' (If there is no reset signal)
   // start each of these loops by storing the value 26'h0 in the led_counter variable
   // stores the value 000000000000000000000000000 in led_counter
   // A useful link on how numbers are read in verilog:
   // http://web.engr.oregonstate.edu/~traylor/ece474/lecture_verilog/beamer/verilog_number_literals.pdf
   
   end 
   else begin led_counter <= led_counter + 26'h1; --> This time does something if there is a reset signal. Want to find where the
   // reset signal is being set. takes the 26 bit value of led_counter and adds 1 like: led_counter + 00000000000000000000000001. Not
   // sure wether '<=' meas less than or equal to or means store that value
   end 
end 

assign led_o = {led_reg[7:4],led_counter[25],led_reg[2:0]}; // led_o  probably means 'LED output.' This is the 8 bit wide register 
// storing the output led voltage level. It looks like it assigns the high order bit of led_counter to the 3rd LED. 





//---------------------------------------------------------------------------------
//
//  Read device DNA --> Why is it necessary to read the device DNA? 

wire           dna_dout  ; --> not really sure what this is...
reg            dna_clk   ; --> I'm also guessing just defining another clock cycle for whatever operations are to be performed. Why 
//not use the bus clock?

reg            dna_read  ; --> Some value probably related to read enabling the device Dna

reg            dna_shift ; --> Shift register maybe? (A register that allows the contents to be moved to the left or right, like if you
// wanted to multiply or divide by 2 for your binary number)

reg  [ 9-1: 0] dna_cnt   ; --> some 9 bit counter variable for the DNA

reg  [57-1: 0] dna_value ; --> the 57 bit DNA value
reg            dna_done  ; --> Some value probably also used in a conditional statement to determine when your done processing the DNA

always @(posedge sys_clk_i) begin // always do something on the rising clock edge. Why are we using the system clock and not the
// dna_clock

   if (sys_rstn_i == 1'b0) begin // if the reset signal equals zero this time. This is happens in addition to storing 26'h0 in 
   // led_counter. So everytime there isn't a reset signal the value zero is stored in led_counter and something related to reading the
   // device DNA happens. 
   
      dna_clk   <=  1'b0 ; // set the dna_clock to the same value of the sys_clk_i
      dna_read  <=  1'b0 ; // set dna_read to 1 
      dna_shift <=  1'b0 ; // set dna_shift to 1 --> not really sure if dna_shift is some serial input to a shift register or the
      // 'advance' signal, or the signal for the register to perform the shift
      dna_cnt   <=  9'd0 ; // --> set all of the bits i dna_count to 0
      dna_value <= 57'd0 ; // --> dna_value is originally set to 57 bits of 0
      dna_done  <=  1'b0 ; // --> dna_done is set to 1
      
   end
   else begin
      if (!dna_done) // if dna_done ==0
         dna_cnt <= dna_cnt + 1'd1 ; // increase dna-count by 1

      dna_clk <= dna_cnt[2] ; // set dna_clock now to the third bit of dna_count. If there is no reset signal then set dna_clock to
      // the same as system clock, otherwise clock it to oscillations of the third bit of dna_cnt (assuming dna_done is equal to 0). 
      
      dna_read  <= (dna_cnt < 9'd10); // if dna_cnt is less than 10, store a 1 in dna_read 
      dna_shift <= (dna_cnt > 9'd18); // if dna_cnt is greater than 18, store a 1 in dna_shift

      if ((dna_cnt[2:0]==3'h0) && !dna_done) // if the first 3 bits of dna_cnt are equal to 000, and dna_done is equal to 0 
         dna_value <= {dna_value[57-2:0], dna_dout}; // assign the higher 54 bits of dna_value to dna_value, and then put dna_dout as
         // the remaining 3 bits

      if (dna_cnt > 9'd465) // if dna_cnt > 111010001
         dna_done <= 1'b1; // assign 1 to dna_done

   end
end

DNA_PORT #( .SIM_DNA_VALUE(57'h0823456789ABCDE) ) // Specifies a sample 57-bit DNA value for simulation
i_DNA 
(
  .DOUT  ( dna_dout   ), // 1-bit output: DNA output data.
  .CLK   ( dna_clk    ), // 1-bit input: Clock input.
  .DIN   ( 1'b0       ), // 1-bit input: User data input pin.
  .READ  ( dna_read   ), // 1-bit input: Active high load DNA, active low read input.
  .SHIFT ( dna_shift  )  // 1-bit input: Active high shift enable input.
);





//---------------------------------------------------------------------------------
//
//  Desing identification

wire [32-1: 0] id_value ;

assign id_value[31: 4] = 28'h0 ; // reserved
assign id_value[ 3: 0] =  4'h1 ; // board type   1-release1





//---------------------------------------------------------------------------------
//
//  System bus connection

always @(posedge sys_clk_i) begin
   if (sys_rstn_i == 1'b0) begin
      led_reg[7:0] <= 8'h0 ;
      exp_p_dat_o  <= 8'h0 ;
      exp_p_dir_o  <= 8'h0 ;
      exp_n_dat_o  <= 8'h0 ;
      exp_n_dir_o  <= 8'h0 ;
   end
   else begin
      if (sys_wen_i) begin
         if (sys_addr_i[19:0]==20'h10)   exp_p_dir_o  <= sys_wdata_i[8-1:0] ;
         if (sys_addr_i[19:0]==20'h14)   exp_n_dir_o  <= sys_wdata_i[8-1:0] ;
         if (sys_addr_i[19:0]==20'h18)   exp_p_dat_o  <= sys_wdata_i[8-1:0] ;
         if (sys_addr_i[19:0]==20'h1C)   exp_n_dat_o  <= sys_wdata_i[8-1:0] ;

         if (sys_addr_i[19:0]==20'h30)   led_reg[7:0] <= sys_wdata_i[8-1:0] ;
      end
   end
end





always @(*) begin
   sys_err_o <= 1'b0 ;

   casez (sys_addr_i[19:0])
     20'h00000 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {               id_value  }                          ; end
     20'h00004 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {               dna_value[31: 0] }                   ; end
     20'h00008 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32-25{1'b0}}, dna_value[56:32] }                   ; end

     20'h00010 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32- 8{1'b0}}, exp_p_dir_o }                        ; end
     20'h00014 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32- 8{1'b0}}, exp_n_dir_o }                        ; end
     20'h00018 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32- 8{1'b0}}, exp_p_dat_o }                        ; end
     20'h0001C : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32- 8{1'b0}}, exp_n_dat_o }                        ; end
     20'h00020 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32- 8{1'b0}}, exp_p_dat_i }                        ; end
     20'h00024 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32- 8{1'b0}}, exp_n_dat_i }                        ; end

     20'h00200 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32-12{1'b0}}, adc_v_i }                            ; end
     20'h00204 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32-12{1'b0}}, adc_temp_i }                         ; end
     20'h00208 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32-12{1'b0}}, adc_pint_i }                         ; end
     20'h0020c : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32-12{1'b0}}, adc_paux_i }                         ; end
     20'h00210 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32-12{1'b0}}, adc_bram_i }                         ; end
     20'h00214 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32-12{1'b0}}, adc_int_i }                          ; end
     20'h00218 : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32-12{1'b0}}, adc_aux_i }                          ; end
     20'h0021c : begin sys_ack_o <= 1'b1;          sys_rdata_o <= {{32-12{1'b0}}, adc_ddr_i }                          ; end

       default : begin sys_ack_o <= 1'b1;          sys_rdata_o <=  32'h0                                               ; end
   endcase
end





endmodule

