//configuration  for  reset agent
  class rst_cfg extends uvm_object;
       //factory registration 
       `uvm_object_utils(rst_cfg)
        //is_active parameter
        uvm_active_passive_enum is_active;
        //virtual interface
        virtual reset_interface vif;
       //extern funtion 
        extern function new (string name="rst_cfg");
  endclass
  
  //constructor new
         function rst_cfg::new (string name="rst_cfg");
            super.new(name);
         endfunction



