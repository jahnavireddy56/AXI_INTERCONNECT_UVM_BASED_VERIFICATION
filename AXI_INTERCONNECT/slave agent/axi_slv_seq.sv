//sequence class for axi slave
  class s_seq extends uvm_sequence#(s_xtn);
       //factory registration 
       `uvm_object_utils(s_seq)
       //extern funtion 
        extern function new (string name="s_seq");
  endclass
  
  //constructor new
         function s_seq::new (string name="s_seq");
            super.new(name);
         endfunction



