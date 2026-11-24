//transaction class for  axi master
  class m_xtn extends uvm_sequence_item;
       //factory registration 
       //`uvm_object_utils(m_xtn)
        parameter ADDR=32,
                  DATA=32,
                  ID=8;
       //PROPERTIES
       //------------------- write address chanel -----------------------
         rand bit [ID-1:0]   awid;
         rand bit [ADDR-1:0] awaddr;
         rand bit [3:0]      awlen;
         rand bit [2:0]      awsize;
         rand bit [1:0]      awburst;
         rand bit            awvalid;
         rand bit            awlock;
         rand bit [3:0]      awcache;
         rand bit [2:0]      awprot;
         rand bit [3:0]      awqos;
         rand bit            awuser;
         rand bit            awready;
       
       //----------------------write data chanel-----------------------------
        rand bit [DATA-1:0] wdata[];
      //  rand bit [ID-1:0]   wid;
        rand bit [3:0]      wstrb[];
        rand bit            wlast;
        rand bit            wvalid;
        rand bit            wuser;
        rand bit            wready;

       //---------------------write response channel----------------------
       rand  bit [ID-1:0]   bid;
       rand  bit [1:0]      bresp;
       rand  bit            bvalid;
       rand  bit            bready;
       rand  bit            buser;

      //---------------------read address channel---------------
        rand bit [ID-1:0]   arid;
        rand bit [ADDR-1:0] araddr;
        rand bit [3:0]      arlen;
        rand bit [2:0]      arsize;
        rand bit [1:0]      arburst;
        rand bit [1:0]      arlock;
        rand bit [3:0]      arcache;
        rand bit [2:0]      arprot;
        rand bit            aruser;
        rand bit            arqos;
        rand bit            arvalid;
        rand bit            arready;
       
      //---------------------read data channel-------------------
        rand     bit [ID-1:0]   rid;
        rand     bit [DATA-1:0] rdata[];
        rand     bit [1:0]      rresp[];
        rand     bit            rlast;
        rand     bit            ruser;
        rand     bit            rvalid;
        rand     bit            rready;

     //------------------------local variables -------------------
         bit [ADDR-1:0] w_addr[];
         bit [ADDR-1:0] r_addr[];    
        //to select slave  
        rand bit [1:0] r_slave;
        rand bit [1:0] w_slave;
        //write and read address calculation 
        int w_wrap_lower_boundary;
        int w_wrap_upper_boundary;
        int r_wrap_lower_boundary;
        int r_wrap_upper_boundary;

    //----------------------field macros----------------------
        `uvm_object_utils_begin(m_xtn)
             `uvm_field_int(awid,UVM_ALL_ON)
             `uvm_field_int(awaddr,UVM_ALL_ON)
             `uvm_field_int(awlen,UVM_ALL_ON)
             `uvm_field_int(awsize,UVM_ALL_ON)
             `uvm_field_int(awburst,UVM_ALL_ON)
             `uvm_field_int(awvalid,UVM_ALL_ON)
             `uvm_field_int(awlock,UVM_ALL_ON)
             `uvm_field_int(awcache,UVM_ALL_ON)
             `uvm_field_int(awprot,UVM_ALL_ON)
             `uvm_field_int(awqos,UVM_ALL_ON)
             `uvm_field_int(awuser,UVM_ALL_ON)
             `uvm_field_int(awready,UVM_ALL_ON)
          //   `uvm_field_int(awid,UVM_ALL_ON)
             `uvm_field_array_int(wdata,UVM_ALL_ON)
             `uvm_field_array_int(wstrb,UVM_ALL_ON)
             `uvm_field_int(wlast,UVM_ALL_ON)
             `uvm_field_int(wvalid,UVM_ALL_ON)
             `uvm_field_int(wready,UVM_ALL_ON)
             `uvm_field_int(bresp,UVM_ALL_ON)
             `uvm_field_int(bvalid,UVM_ALL_ON)
             `uvm_field_int(bready,UVM_ALL_ON)
             `uvm_field_int(arid,UVM_ALL_ON)
             `uvm_field_int(araddr,UVM_ALL_ON)
             `uvm_field_int(arlen,UVM_ALL_ON)
             `uvm_field_int(arsize,UVM_ALL_ON)
             `uvm_field_int(arburst,UVM_ALL_ON)
             `uvm_field_int(arlock,UVM_ALL_ON)
             `uvm_field_int(arcache,UVM_ALL_ON)
             `uvm_field_int(arprot,UVM_ALL_ON)
             `uvm_field_int(arqos,UVM_ALL_ON)
             `uvm_field_int(arvalid,UVM_ALL_ON)
             `uvm_field_int(arready,UVM_ALL_ON)
             `uvm_field_array_int(rdata,UVM_ALL_ON)
             `uvm_field_array_int(rresp,UVM_ALL_ON)
             `uvm_field_int(rlast,UVM_ALL_ON)
             `uvm_field_int(ruser,UVM_ALL_ON)
             `uvm_field_int(rvalid,UVM_ALL_ON)
             `uvm_field_int(rready,UVM_ALL_ON)
        `uvm_object_utils_end
       //-------------------------------------------------//
       //                  CONSTRAINTS                    //
       //------------------------------------------------//
	//constraints

//	constraint vald_reset {resetn==1'b1;}
	
	constraint valid_awvalid {awvalid dist{1:=499,0:=1};}

	
	constraint valid_R_ID {arid inside {[1:255]};
				rid == arid;
					}
	constraint valid_write{awid==bid;}
	
	constraint valid_awuser{ awuser == 0;
				wuser == awuser;
				buser == awuser;}
	
	constraint valid_ARUSER { aruser == 0;
				  ruser == aruser;
				}


	constraint valid_burst_awaddr {
					solve awsize before awburst;
					if(awburst==2)
						if(awsize==1)
							awaddr%2==0;
						else if(awsize==2)
							awaddr%4==0;
				      }

	constraint valid_burst_araddr {
					solve arsize before arburst;
						if(arburst==2)
							if(arsize==1)
								araddr%2==0;
							else if(arsize==2)
								araddr%4==0;
				     }

	constraint valid_awaddr {
					solve w_slave before awaddr;
					solve awburst before awaddr;
					if(w_slave==0)
						awaddr inside {[32'h4000_0000 : 32'h4000_0fff]};
					else if(w_slave==1)
						awaddr inside {[32'h4000_1000 : 32'h4000_1fff]};
					else if(w_slave==2)
						awaddr inside {[32'h4000_2000 : 32'h4000_2fff]};
				}

	constraint valid_araddr {
					solve r_slave before araddr;
					solve arburst before araddr;
					if(r_slave==0)
						araddr inside {[32'h4000_0000 : 32'h4000_0fff]};
					else if(r_slave==1)
						araddr inside {[32'h4000_1000 : 32'h4000_1fff]};
					else if(r_slave==2)
						araddr inside {[32'h4000_2000 : 32'h4000_2fff]};
				}

	constraint valid_awburst { awburst inside {0,1,2};}
	constraint valid_arburst { arburst inside {0,1,2};}
	

	constraint valid_awsize { 8*(2**awsize) <=32;}
	constraint valid_arsize { 8*(2**arsize) <=32;}

	constraint vaid_wadata_SIZE {
					wdata.size==awlen+1;
				   }

	constraint valid_rdata_SIZE {
					rdata.size==arlen+1;
				    }

	constraint valid_araddr_rresp { rresp.size== rdata.size;}

	constraint valid_awlen {
					solve awburst before awlen;
					if(awburst==0)
						soft awlen inside {[0:2]};
					else if(awburst==1)
						soft awlen inside {[1:2]};
					else if(awburst==2)
						soft awlen inside {1,3};
			      }

	constraint valid_arlen {
					solve arburst before arlen;
					if(arburst==0)
						soft arlen inside {[0:255]};
					else if(arburst==1)
						soft arlen inside {[1:255]};
					else if(arburst==2)
						soft arlen inside {1,3,7,15,31,63,127,255};
			      }

	constraint valid_rresp{
					foreach(rresp[i])
						rresp[i]==0;} //0 means OKAY
	
	constraint valid_BRESP{
					bresp==0;
				}

     
    /*   //CASE:1 no of beats to be transfered is [len+1]to each address
       constraint data_size {wdata.size() ==awlen+1;
                             rdata.size() ==arlen+1;
                            }

       //CASE:2 no_of_bytes in each beat is [2**size]
       // constraint bytes_in_each_transfer {foreach(awdata[i])
         //                                   awdata[i]==[2**awsize]*8 awdata[i];;
           //                               foreach(ardata[i])
             //                               ardata[i]==[2**arsize]*8 awdata[i];
               //                           }

      //CASE 3: burst types are fixed,incr,wrap only burst should inside 0,1,2 only 3 reserved
       constraint valid_burst_type {awburst inside {0,1,2};
                                    arburst inside {0,1,2};}
       
      //CASE 4:when it is wrap brust type then address must aligned to the size of transfer  and length of burst is 2,4,8,or 16 
       constraint valid_w_wrap_burst {if(awburst==2'd 2)
                                       awlen inside {1,3,7,15};
                                      if(arburst==2'd2)
                                       arlen inside {1,3,7,15};
                                      }

      //CASE 5: size should not more data bytes
       constraint valid_w_size {awsize<=(DATA/8)-2;}
       constraint valid_r_size {arsize<=(DATA/8)-2;}

      //CASE 6:write address id should same write response id and write data id &same like read 
       constraint valid_w_id {awid==bid; }
       constraint valid_r_id {arid==rid;}
       
      //CASE 7:if burst type is wrap and fixed then address is aligned
      constraint valid_addrs_wrap_fixed {if(awburst==2'b00||awburst==2'b10)
                                              awaddr==(awaddr%2**awsize)==0;
                                         if(arburst==2'b00||arburst==2'b10)
                                              araddr==(araddr%2**arsize)==0;}
      
      //CASE 8:Addr should not cross 4kb boundary i.e.,4096
      constraint valid_addr {awaddr<=4096; araddr<=4096;}

      //CASE 9: slave selection and address per slave
      constraint valid_w_slave_address { solve w_slave before awaddr;
                                          if(w_slave==2'b00)
                                            awaddr inside {[32'h4000_0000:32'h4000_0fff]};
                                          if(w_slave==2'b01)
                                            awaddr inside {[32'h4000_1000:32'h4000_1fff]};
                                          if(w_slave==2'b10)
                                            awaddr inside {[32'h4000_2000:32'h4000_2fff]};
                                        }
      constraint valid_r_slave_address { solve r_slave before araddr;
                                          if(r_slave==2'd0)
                                            araddr inside {[32'h4000_0000:32'h4000_0fff]};
                                          if(r_slave==2'd1)
                                            araddr inside {[32'h4000_1000:32'h4000_1fff]};
                                          if(r_slave==2'd2)
                                            araddr inside {[32'h4000_2000:32'h4000_2fff]};
                                        }*/

      //extern funtion 
        extern function new (string name="m_xtn");
      //case 10:calculating write address and read address and strobe calculation 
       extern function write_addr_cal();
       extern function read_addr_cal();
       extern function strobe_cal();
       extern function void post_randomization();

  endclass
  
  //constructor new
         function m_xtn::new (string name="m_xtn");
            super.new(name);
         endfunction

  //post randomization
         function void m_xtn::post_randomization();
              write_addr_cal();
              read_addr_cal();
              strobe_cal();
         endfunction

  //write address calculation 
       function  m_xtn::write_addr_cal();
            bit k=0;
            int w_start_addr=awaddr;
            int w_no_of_bytes=2**(awsize);
            int w_burst_length=(awlen)+1;
            int w_aligned_addr=(int'(w_start_addr/w_no_of_bytes))*(w_no_of_bytes);

            w_addr =new[awlen+1];

            w_wrap_lower_boundary=(int'(awaddr/(w_no_of_bytes*w_burst_length)))*(w_no_of_bytes*w_burst_length);
            w_wrap_upper_boundary=w_wrap_lower_boundary+(w_no_of_bytes*w_burst_length);

            w_addr[0]=awaddr;
            
            for(int i=1;i<=(awlen+1);i++)
                 begin
                    if(awburst==0)
                        w_addr[i]=awaddr;
                    else if(awburst==1)
                        w_addr[i]=(int'(awaddr/(w_no_of_bytes*w_no_of_bytes)))+(i*(w_no_of_bytes));
                    else if(awburst==2)
                      
                        if(k==0)
                               begin
                                   w_addr[i]=(int'(awaddr/w_no_of_bytes)*(w_no_of_bytes))+(i*(w_no_of_bytes));
                                   if(w_addr[i]==w_wrap_upper_boundary)
                                        begin
                                            w_addr[i]=w_wrap_lower_boundary;
                                            k++;
                                        end
                                end  
                         else
                            w_addr[i]=awaddr+(i*w_no_of_bytes)-(w_no_of_bytes*w_burst_length);
                  end
        endfunction

   //STROBE CALCULATION
        function m_xtn::strobe_cal();
           int data_bus_bytes=DATA/8;
           int lower_byte_lane;
           int upper_byte_lane;
           int lower_byte_lane_0;
           int upper_byte_lane_0;
           int start_addr=awaddr;
           int no_of_bytes=2*awsize;
           int aligned_addr=(int'(start_addr/no_of_bytes))*(no_of_bytes);

           wstrb=new[awlen+1];

           lower_byte_lane_0=start_addr-(int'(start_addr/data_bus_bytes))*data_bus_bytes;
           upper_byte_lane_0=(aligned_addr+no_of_bytes)-(int'(start_addr/data_bus_bytes))*(data_bus_bytes);
            
           for(int j=lower_byte_lane_0;j<=upper_byte_lane_0;j++)
                   begin
                        wstrb[0][j]=1;
                   end
   
            for (int i=1;i<(wstrb.size());i++)
                 begin
                     lower_byte_lane=awaddr[i]-(int'(awaddr[i]/data_bus_bytes))*data_bus_bytes;
                     upper_byte_lane=lower_byte_lane+no_of_bytes-1;
                     for(int j=lower_byte_lane;j<=upper_byte_lane;j++)
                       wstrb[i][j]=1;
                 end
         endfunction
          
//read address calculation 
        function  m_xtn::read_addr_cal();
            bit k=0;
            int r_start_addr=araddr;
            int r_no_of_bytes=2**(arsize);
            int r_burst_length=(arlen)+1;
            int r_aligned_addr=(int'(r_start_addr/r_no_of_bytes))*(r_no_of_bytes);

            r_addr =new[arlen+1];

            r_wrap_lower_boundary=(int'(araddr/(r_no_of_bytes*r_burst_length)))*(r_no_of_bytes*r_burst_length);
            r_wrap_upper_boundary=r_wrap_lower_boundary+(r_no_of_bytes*r_burst_length);

            r_addr[0]=araddr;
            
            for(int i=1;i<=(arlen+1);i++)
                 begin
                    if(arburst==0)
                        r_addr[i]=araddr;
                    else if(arburst==1)
                        r_addr[i]=(int'(araddr/(r_no_of_bytes*r_no_of_bytes)))+(i*(r_no_of_bytes));
                    else if(arburst==2)
                      
                        if(k==0)
                               begin
                                   r_addr[i]=(int'(araddr/r_no_of_bytes)*(r_no_of_bytes))+(i*(r_no_of_bytes));
                                   if(r_addr[i]==r_wrap_upper_boundary)
                                        begin
                                            r_addr[i]=r_wrap_lower_boundary;
                                            k++;
                                        end
                                end  
                         else
                            r_addr[i]=araddr+(i*r_no_of_bytes)-(r_no_of_bytes*r_burst_length);
                  end
        endfunction

                     
                    
           
