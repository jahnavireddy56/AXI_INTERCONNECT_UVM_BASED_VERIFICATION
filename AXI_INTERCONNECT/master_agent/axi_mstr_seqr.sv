//  sequncer class for axi master
   class m_seqr extends uvm_sequencer#(m_xtn);
      //factory register 
      `uvm_component_utils(m_seqr)
      //extern functions 
      extern function new (string name="m_seqr",uvm_component parent);
   endclass
    
  //constructor new
      function m_seqr::new (string name="m_seqr",uvm_component parent);
        super.new(name,parent);
      endfunction  
