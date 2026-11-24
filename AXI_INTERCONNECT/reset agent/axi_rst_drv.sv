//  driver class for axi master
   class  rst_drv extends uvm_driver#(rst_xtn);
      //factory register 
      `uvm_component_utils( rst_drv)
      //configuration 
      rst_cfg reset_cfg;
      //virtual interface 
       virtual reset_interface.RST_DRV_MP reset_vif;

      //extern functions 
        extern function new (string name="rst_drv",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
   endclass
    
  //constructor new
      function  rst_drv::new (string name="rst_drv",uvm_component parent);
        super.new(name,parent);
      endfunction
  //------------------------build phase-----------------------
       function void rst_drv :: build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(rst_cfg) :: get(this,"","rst_cfg",reset_cfg))
			`uvm_fatal("rst_drv","getting cojnfig failed")
	
	endfunction
  //----------------------connect phase --------------------------

	function void rst_drv :: connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		reset_vif=reset_cfg.vif;
	endfunction
 //------------------------ run phase -------------------------
	task rst_drv :: run_phase(uvm_phase phase);
		
		@(reset_vif.rst_drv_cb);
		reset_vif.rst_drv_cb.reset<=1'b1;
		@(reset_vif.rst_drv_cb);
		reset_vif.rst_drv_cb.reset<=1'b0;
              // `uvm_info("RESET",$sformf("reset drv time%t",$time),UVM_MEDIUM)
	endtask

  


