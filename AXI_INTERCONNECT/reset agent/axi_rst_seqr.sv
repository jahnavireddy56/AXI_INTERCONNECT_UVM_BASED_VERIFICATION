//  sequncer class for reset agent
   class rst_seqr extends uvm_sequencer#(rst_xtn);
      //factory register 
      `uvm_component_utils(rst_seqr)
      //extern functions 
      extern function new (string name="rst_seqr",uvm_component parent);
   endclass
    
  //constructor new
      function rst_seqr::new (string name="rst_seqr",uvm_component parent);
        super.new(name,parent);
      endfunction  

