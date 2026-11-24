//  sequncer class for axi slave
   class s_seqr extends uvm_sequencer#(s_xtn);
      //factory register 
      `uvm_component_utils(s_seqr)
      //extern functions 
      extern function new (string name="s_seqr",uvm_component parent);
   endclass
    
  //constructor new
      function s_seqr::new (string name="s_seqr",uvm_component parent);
        super.new(name,parent);
      endfunction  

