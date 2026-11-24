//  sequncer class for reset agent
   class  rst_mon extends uvm_monitor;
      //factory register 
      `uvm_component_utils( rst_mon)
      //cinfiguration handle
        rst_cfg  reset_cfg;
	rst_xtn xtn;
      //analysis port
	uvm_analysis_port#(rst_xtn) reset_ap;

      //virtual interface 
      virtual reset_interface.RST_MON_MP reset_vif;

      //extern functions 
        extern function new (string name=" rst_mon",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

   endclass
    
  //constructor new
      function  rst_mon::new (string name=" rst_mon",uvm_component parent);
        super.new(name,parent);
        reset_ap=new("reset_ap",this);
      endfunction  
  //-------------------build phase -------------------------
	function void rst_mon :: build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(rst_cfg) :: get(this,"","rst_cfg",reset_cfg))
			`uvm_fatal("rst_mon","getting cojnfig failed")
	
	endfunction
 //-----------------------connect phase------------------------
	function void rst_mon :: connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		reset_vif=reset_cfg.vif;
	endfunction

//-----------------------run phase---------------------------
	task rst_mon :: run_phase(uvm_phase phase);
	repeat(2)
		begin
		xtn=rst_xtn::type_id::create("xtn");		
		
		@(reset_vif.rst_mon_cb);

		xtn.reset=reset_vif.rst_mon_cb.reset;
        //       `uvm_info("RESET",$sformf("reset MON %s",xtn.sprint),UVM_MEDIUM)

		reset_ap.write(xtn);

		end
		
	endtask


